---
layout: post
status: publish
published: true
title: 'Debug Your GUI: Redirecting and Distributing System.out'
author: Andrew Kroh
date: '2009-07-02 22:48:22 -0400'
date_gmt: '2009-07-03 03:48:22 -0400'
categories:
- uncategorized
tags:
- java
---
Recently I was reading _Swing Hacks_ by by [Joshua
Marinacci](http://www.oreillynet.com/pub/au/2200?x-t=book.view) and [Chris
Adamson](http://www.oreillynet.com/pub/au/1045?x-t=book.view) (ISBN:
978-0-596-00907-6). I came across Hack 95: Debug Your GUI which basically
recommends building a dialog window containing a JTextArea that has the standard
output streams routed to it. I thought this hack could be useful for debugging
deployed applications since it makes it very easy for customers to get access to
the console output.

The problem with this is that during development I like to look at the console
output in Eclipse or from the terminal where I launched the application. So in
order to get the standard streams routed to both the the normal standard output
and to the debug dialog window I designed a [utility
class](https://gist.github.com/andrewkroh/50f83a579cccf2717e68). The utility
class redirects the standard streams to a custom OutputStream which then
distributes the output to the normal standard output/error and also to any
additional registered listeners like a debug dialog window.


[![debug_console]({{ site.baseurl }}/assets/uploads/2013/02/debug_console.png)]({{ site.baseurl }}/assets/uploads/2013/02/debug_console.png)

Figure 1: Custom Debug Console in Swing

[![eclipse_console]({{ site.baseurl }}/assets/uploads/2013/02/eclipse_console.png)]({{ site.baseurl }}/assets/uploads/2013/02/eclipse_console.png)


Figure 2: Eclipse Console Output
