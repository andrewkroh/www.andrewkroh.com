---
layout: post
status: publish
published: true
title: Configuring CIFS&#47;SMB File Sharing on Solaris
author: Andrew Kroh
date: '2011-03-10 00:58:39 -0500'
date_gmt: '2011-03-10 04:58:39 -0500'
categories:
- Solaris
tags: []
---
Solaris 11 comes with the CIFS/SMB server installed so you do not need to
download or install any additional packages. You simply need to enable the SMB
server, configure the PAM module to allow authentication of CIFS users, and
regenerate passwords for users.

```
$ svcadm enable -rs smb/server  
svcadm: svc:/milestone/network depends on svc:/network/physical, which has multiple instances.

$ smbadm join -w JONESNET  
After joining JONESNET the smb service will be restarted automatically.  
Would you like to continue? [no]: yes  
Successfully joined JONESNET
```

Now you have the server up and running, but no one will be able to log in. You
need to modify /etc/pam.conf to add the following lines.

```
$ pfexec vim /etc/pam.conf  
# PAM Module for CIFS/SMB Login  
other password required pam_smb_passwd.so.1 nowarn
```

After the PAM module is installed, the passwd command automatically generates
CIFS-suitable passwords for new users. You must run the passwd command to
generate CIFS-style passwords for existing users.

```
$ passwd  
passwd: Changing password for joe  
New Password:  
Re-enter new Password:  
passwd: password successfully changed for joe
```

Finally user joe can now access CIFS shares on your Solaris box.

To view the shares available on the server you can read /etc/dfs/sharetab. Below
you will see a share named testshare that is mounted at /storeagepool/testshare
on the server.

```
$ cat /etc/dfs/sharetab  
/var/smb/cvol                  c$              smb   -    Default Share  
/storeagepool/testshare        testshare       smb   -  
```

#### References

[Getting Started With the Solaris CIFS Service -
Genunix](http://wiki.genunix.org:8080/wiki/index.php/Getting_Started_With_the_Solaris_CIFS_Service)
