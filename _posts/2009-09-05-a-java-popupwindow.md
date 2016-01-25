---
layout: post
status: publish
published: true
title: A Java PopupWindow
author: Andrew Kroh
date: '2009-09-05 23:18:25 -0400'
date_gmt: '2009-09-06 04:18:25 -0400'
categories:
- uncategorized
tags:
  - java
---
Have you ever wanted to display a popup to enter text or choose a color? Well if
you have then you probably know that Swing does not have a component with this
functionality. There is the JPopupMenu, but if you add components to it that
menu will become hidden when any of the added components gain focus. I created a
new component that displays a JPanel within a JWindow. The JWindow will hide
itself when it loses focus, a click occurs outside of the JWindow, or the
JWindow's ancestor moves. A demo is worth a 1000 words. The demo was inspired by
the SMS button on Google Voice.

[View Source](https://github.com/andrewkroh/crowbird-techblog/tree/master/swing-popup-window/src/main/java/com/krohinc/ui/util)

[<img src="{{ site.baseurl }}/assets/uploads/2013/02/popupwindow-sc.png" alt="Popup window screenshot" style="width: 50%;"/>]({{ site.baseurl }}/assets/uploads/2013/02/popupwindow-sc.png)

Figure 1: Screen Shot of Demo Application
