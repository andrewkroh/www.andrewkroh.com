---
layout: post
status: publish
published: true
title: Listing Hard Disk Serial Numbers on Solaris
author: Andrew Kroh
date: '2011-03-10 00:55:05 -0500'
date_gmt: '2011-03-10 04:55:05 -0500'
categories:
- Solaris
tags: []
---
When a device has a name like `/dev/dsk/c7t0d0` how do you know what physical
hard disk this maps to in your Solaris system? Locating a physical hard disk by
its device name can be achieved by having Solaris list the device serial numbers
and then looking at the labels on the hard disks.

You can get Solaris to spit out the serial numbers by running the following command.

```
$ cfgadm -alv | grep SN
sata0/0::dsk/c7t0d0 connected configured ok Mod: HL-DT-ST DVDRAM GH22NS50 FRev: TN01 SN: K2D89DJOIJL977
sata0/1::dsk/c7t1d0 connected configured ok Mod: WDC WD1600AAJS-08L7A0 FRev: 03.03E03 SN: WD-WMAV7899594
sata0/2::dsk/c7t2d0 connected configured ok Mod: WDC WD1600AAJS-08L7A0 FRev: 03.03E03 SN: WD-WCAV8574849
sata0/3::dsk/c7t3d0 connected configured ok Mod: ST2000DL003-9VT166 FRev: CC32 SN: 5YD283739
sata0/4::dsk/c7t4d0 connected configured ok Mod: ST2000DL003-9VT166 FRev: CC32 SN: 5YD838394
sata0/5::dsk/c7t5d0 connected configured ok Mod: ST2000DL003-9VT166 FRev: CC32 SN: 5YD098784
```

