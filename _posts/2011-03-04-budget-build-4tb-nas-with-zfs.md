---
layout: post
status: publish
published: true
title: Budget Build - 4TB NAS with ZFS
author: Andrew Kroh
date: '2011-03-04 23:54:14 -0500'
date_gmt: '2011-03-05 03:54:14 -0500'
categories:
- solaris
tags: []
---
This page details my budget build of a 4TB NAS based on Solaris and ZFS.

<table>
<tbody>
<tr>
<th>Bill of Materials</th>
<th style="width: 7em">Price</th>
</tr>

<tr>
<td>Motherboard: BIOSTAR TA890GXB</td>
<td>$95</td>
</tr>

<tr>
<td>Memory: PNY Optima 4GB DDR3 1333MHz</td>
<td>$39</td>
</tr>

<tr>
<td>Power Supply: Ultra 750W (already owned)</td>
<td>$70</td>
</tr>

<tr>
<td>Optical Drive: LG GH22NS50AUAU DVD Writer - DVD+R 22x, DVD+RW 8X, DVD-RW 6x, DVD-RAM 12x, SATA (already owned)</td>
<td>$30</td>
</tr>

<tr>
<td>Hard Disks (System): WD 160GB SATA 3Gbps</td>
<td>2x $23</td>
</tr>

<tr>
<td>Hard Disks (Data): Seagate Barracuda Green 2TB SATA 6Gbps</td>
<td>3x $80</td>
</tr>

<tr>
<td>Case: Ultra eXo ATX Mid-Tower Aluminum Case (already owned)</td>
<td>$70</td>
</tr>

<tr>
<td style="text-align: right">New Parts&nbsp;&nbsp;</td>
<td>$483</td>
</tr>

<tr>
<td style="text-align: right">Recycled Parts&nbsp;&nbsp;</td>
<td>$170</td>
</tr>

<tr>
<td style="text-align: right; font-weight: bold;">Total&nbsp;&nbsp;</td>
<td>$653</td>
</tr>
</tbody>
</table>

This system is a replacement for an older and much smaller NAS I put together
from old parts. The old system was 32-bit based and lacked onboard SATA support
because it was manufactured before SATA was in existance. The 1TB limitation on
32-bit Solaris makes upgrading to larger drives a silly move. Why purchase a
1TB drive when you can purchase a 2TB drive for 10 dollars more?

The new system is a 64-bit dual core AMD running at 3.1GHz with 4GB of
memory. The system disks which hold the OS and other essential data are
configured in a ZFS mirror for redundancy. I've found that most of my Solaris
installations with all the random server software I use normally consume about
30GB; the disks I bought hold 160GB and should be more than sufficient. With 6
SATA ports available on the motherboard and one used by the DVD drive and two
used by the system disks I have room to support three SATA dsks for data
storage. Additional data drives can be added later by using a PCI-e SATA/SAS
add-on card. For more information on Solaris compatible SATA/SAS cards see
this [excellent blog post](http://blog.zorinaq.com/?e=10).

The three data drives are 2TB. Simple math says this system can hold 6TB of
data, but that would be without redundancy and would offer no protection
against a disk failure. To gain protection against a single disk failure the
disks are setup in a RAID-Z1 configuration which gives us 4TB of usable space.
For more information on
[RAID-Z requirements see RAIDZ Configuration Requirements and Recommendations](http://www.solarisinternals.com/wiki/index.php/ZFS_Best_Practices_Guide#RAIDZ_Configuration_Requirements_and_Recommendations).
