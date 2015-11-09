---
layout: post
status: publish
published: true
title: OpenSolaris
author: Andrew Kroh
date: '2009-12-15 00:29:21 -0500'
date_gmt: '2009-12-15 04:29:21 -0500'
categories:
- solaris
tags: []
---
**Update (February 2011):** Oracle stopped contributing to the OpenSolaris project so it is basically dead. However you can use Oracle Solaris 11 Express at no cost under the Oracle Technology Network Developer license if you are developing, testing, or prototyping applications.

For a long time I have been using Gentoo Linux to run a multipurpose server in my home. I mainly use the server to backup data, host web pages, host a CVS server, and run a proxy server. The hardware is rather modest -- Celeron D 2.93GHz, 512MB, 500GB SATA.

As a data backup server I usually copy files to the server over samba and keep the the original on another machine. This keeps me protected in case of a drive failure. But as a backup strategy I'm not happy because I'd like to be able to move a file to backup server and delete the original. To ensure data on the backup server is protected against loss I need some sort of RAID (Redundant Array of Inexpensive Disks). I considered hardware RAID but ultimately ended up going with software RAID (mostly due to the cost difference).

While searching for the best way to implement software RAID I found OpenSolaris and ZFS. ZFS is OpenSolaris's file system which has features like snapshots, copy-on-write, RAID, automatic integrity checking, and automatic repair. Snapshots are similar to the Time Machine feature in Mac OS X. With all these features I thought it would be great to migrate and give Solaris a try.

I upgraded the computer to have 2.5 GB of RAM and purchased a second SATA drive of 1.5 TB. I had planned to use the new drive in conjunction with the old drive to create 500GB of redundant storage plus an addition 1TB of non-redundant storage. Unfortunately, I found that 1.5TB drive is too large for a 32-bit kernel under OpenSolaris and that it is not possible to create redundant storage using two different size drives without the excess size of the larger disk going unused. The maximum drive size supported by a 32-bit kernel on OpenSolaris is 1TB (assuming that the drive is using standard 512 byte blocks). See this [thread](http://opensolaris.org/jive/thread.jspa?messageID=418900) in the OpenSolaris forums.

Ultimately I decided to purchase two 1TB drives and just run everything from them. I'll make use the old 500GB drive and the 1.5TB drive in another PC.

### Services

These are the services that the Solaris box provides.

- **Web Server** - Sun Java System Web Server - Used to host ViewVC (a web based CVS browser), Gallery (open source photo album organizer), a custom PHP based video browser, and give web based access to backed up files.
- **CVS** - Used to version control various software projects and configuration files.
- **HTTP Proxy/Cache** - Squid - Used to proxy web traffic when I'm connected to a public network. I use ssh to create a secure tunnel to the proxy server so that my web traffic cannot be intercepted or analyzed while connected to a public network like a hotel or a Starbucks.
- **SMB/CIFS** - Used to provide Windows and Mac access to the file server. Solaris has built in support for CIFS (Common Internet File System) and supports access control lists (ACLs).
- **iSCSI** - Used to create an iSCSI drive on Mac that Time Machine can use as a backup disk. Mac OS X doesn't have an iSCSI Initiator built it but Studio Network Solutions has a free one.

### Setup

#### OS Installation

Install OpenSolaris from the downloadable Live CD. During the interactive
installation choose one of the drives and use the whole disk. After installation
is completed you will attach the second disk to create a mirror. Instructions are
located [here](http://dlc.sun.com/osol/docs/content/2008.11/getstart/sliminstall.html).

#### Post-Installation Setup

I like to customize my bash environment. Run these commands to add some aliases
that are sourced when a bash shell is opened. Of course this is completely optional.

```
cd ~  
echo source .bashrc > .bash_profile  
echo alias l=\'ls -la\' >> .bashrc  
echo alias cdh=\'cd ~\' >> .bashrc
```

#### Configuring a Static IP Address

By default DHCP will be enabled after installation. You will probably want to
configure a static IP address for you server. Replace rtls0 with the name of
your network interface card (NIC).

```
# Disable DHCP  
$ svcadm disable nwam  
$ rm /etc/dhcp.rtls0

# Edit /etc/hosts  
# Add a line (this file and /etc/inet/ipnodes are symlinks to /etc/inet/hosts)  
192.168.0.10 kermit.domain.local kermit

# Edit /etc/netmasks  
# Ensure that it contains a line like this  
192.168.0.0 255.255.255.0

# Edit /etc/nsswitch.conf  
# Make the hosts: line contain this  
host: files dns

# Edit /etc/hostname.rtls0  
# This file describes the hostname of the interface  
# It can be either an IP address or a hostname in /etc/hosts  
kermit

# Edit /etc/defaultrouter  
# This should contain the IP address of your gateway  
192.168.0.1

# Edit /etc/resolve.conf  
# This file describes the DNS servers to use (these  
# are for Google DNS followed by my router)  
nameserver 8.8.8.8  
nameserver 8.8.4.4  
nameserver 192.168.0.1

# Reset your NIC  
$ svcadm disable network/physical:default  
$ svcadm enable network/physical:default  
```

#### Creating a ZFS Mirror Pool

The first step is to prepare the second disk by formatting it entirely as a Solaris partition.

```
$ format  
Searching for disks...done

AVAILABLE DISK SELECTIONS:  
0\. c8d0<default cyl="" 60797="" alt="" 2="" hd="" 255="" sec="" 126="">  
/pci@0,0/pci-ide@1f,2/ide@0/cmdk@0,0  
1\. c9d0<default cyl="" 60797="" alt="" 2="" hd="" 255="" sec="" 126="">  
/pci@0,0/pci-ide@1f,2/ide@1/cmdk@0,0  
Specify disk (enter its number): 2  
format> fdisk</default></default>

No fdisk table exists. The default partition for the disk is:

a 100% "SOLARIS System" partition

Type "y" to accept the default partition, otherwise type "n" to edit the  
partition table.  
y
```

Enter "y" and the disk will be formatted.

The next step is to copy the volume table of contents from the first drive to the second drive.

```
$ prtvtoc /dev/rdsk/c8d0s0 | /usr/sbin/fmthard -s - /dev/rdsk/c9d0s0  
fmthard: New volume table of contents now in place.
```

Now the second disk is prepared to be attached to the storage pool to create a mirror.

```
$ zpool attach rpool c8d0s0 c9d0s0  
invalid vdev specification  
use '-f' to override the following errors:  
/dev/dsk/c8d0s0 overlaps with /dev/dsk/c9d0s2  
$ zpool attach -f rpool c8d0s0 c9d0s0
```

Make sure to wait until resilver is done before rebooting.

In the case of a disk failure you would want the second disk to be bootable so
we should install grub and a MBR to the second disk.

```
$ installgrub -m /boot/grub/stage1 /boot/grub/stage2 /dev/rdsk/c9d0s0  
Updating master boot sector destroys existing boot managers (if any).  
continue(y/n)?y  
stage1 written to partition 0 sector 0 (abs 32130)  
stage2 written to partition 0, 271 sectors starting at 50 (abs 32180)  
stage1 written to master boot sector
```

The filesystem should be replicating data from the first disk to the second disk.
You can check on progress by issuing the zpool status command.

```
$ zpool status  
pool: rpool  
state: ONLINE  
status: One or more devices is currently being resilvered. The pool will  
continue to function, possibly in a degraded state.  
action: Wait for the resilver to complete.  
scrub: resilver in progress for 0h1m, 1.81% done, 1h11m to go  
config:

NAME STATE READ WRITE CKSUM  
rpool ONLINE 0 0 0  
mirror ONLINE 0 0 0  
c8d0s0 ONLINE 0 0 0  
c9d0s0 ONLINE 0 0 0 2.06G resilvered

errors: No known data errors  
```

### Miscellaneous Tasks

#### Mounting ext3 Drives as Read-Only on Solaris

Download and install (using pkgadd)
[FSWpart.tar.gz](http://www.belenix.org/distributions/belenix_site/binfiles/FSWpart.tar.gz)
and
[FSWfsmisc.tar.gz](http://www.belenix.org/distributions/belenix_site/binfiles/FSWfsmisc.tar.gz)
from
[http://www.belenix.org/?q=download](http://www.belenix.org/?q=download).

```
$ gunzip -c FSWpart.tar.gz | tar xvf -  
$ pkgadd -d . FSWpart  
$ gunzip -c FSWfsmisc.tar.gz | tar xvf -  
$ pkgadd -d . FSWfsmisc
```

Use format to list the attached hard disks.

```
$ format  
AVAILABLE DISK SELECTIONS:  
0\. c8d0<default cyl="" 60797="" alt="" 2="" hd="" 255="" sec="" 126="">  
/pci@0,0/pci-ide@1f,2/ide@0/cmdk@0,0  
1\. c9d0<default cyl="" 60797="" alt="" 2="" hd="" 255="" sec="" 126="">  
/pci@0,0/pci-ide@1f,2/ide@1/cmdk@0,0</default></default>
```

Exit format using Control-C.

Use prtpart to display the partions on the disk.  

```
$ prtpart /dev/rdsk/c8d0p0 -ldevs
```

Now mount the disk read-only.

```
$ mount -F ext2fs -o ro /dev/rdsk/c8d0p0 /mount_location
```

To unmount the partition use xumount so that the background NFS process is terminated.

```
$ xumount /mount_location
```

The xlsmounts tool can be used to list all ext3 mounted partitions.

```
$ xlsmounts
PHYSICAL DEVICE LOGICAL DEVICE FS PID ADDR Mounted on  
/dev/dsk/c2t0d0p1 /dev/dsk/c2t0d0p1 ntfs 6755 127.0.0.1:/ /mnt
```
