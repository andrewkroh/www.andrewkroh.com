---
layout: post
status: publish
published: true
title: CVS Password Recovery Using Java
author: Andrew Kroh
date: '2010-02-23 23:23:20 -0500'
date_gmt: '2010-02-24 04:23:20 -0500'
categories:
- uncategorized
tags:
  - cvs
---
Have you forgotten your CVS password? If you have performed a cvs login on the
machine in the past then you should have a .cvspass file stored in your home
directory. This file contains an encrypted version of your password, and you can
easily recover your password from it. Its contents will look something like this.

`/1 :pserver:user@server:2401/cvs A:yZZ30 e`

Your password is the cipher text at the end of the line.

This
[Java program](https://github.com/andrewkroh/crowbird-techblog/tree/master/cvs-password/src/main/java/com/krohinc/cvs)
can be used to recover your CVS password.

[![cvs-password]({{ site.baseurl }}/assets/uploads/2013/02/cvs-password.png)]({{ site.baseurl }}/assets/uploads/2013/02/cvs-password.png)

Figure 1: Screenshot of CVS Password Recovery Tool

