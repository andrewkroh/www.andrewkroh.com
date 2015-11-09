---
layout: post
status: publish
published: true
title: JTextArea Tab Traversal Behavior
author: Andrew Kroh
date: '2009-08-26 23:14:42 -0400'
date_gmt: '2009-08-27 04:14:42 -0400'
categories:
- uncategorized
tags:
  - java
---
I found that the JTextArea has a very annoying behavior when you try to tab
traverse through a form that contains one. Once you tab traverse into the
JTextArea you cannot tab traverse out of it because pressing TAB just inserts
an actual tab character. In order to tab traverse to the next component you
must press CTRL+TAB.

My desired behavior for the JTextArea is to be able to use TAB and SHIFT+TAB
to traverse forward and backward, repectively, through a form and to use
CTRL+TAB to insert an actual tab character. By resetting the focus traversal
keys and re-mapping some input keys this can be accomplished in Java. Below is
the code for doing so.

[View Source](https://github.com/andrewkroh/crowbird-techblog/tree/master/textarea-tab-traversal/src/main/java/com/krohinc/ui/util)

[<img src="{{ site.baseurl }}/assets/uploads/2013/02/textarea-traversal-sc.png" alt="Textarea traversal screenshot"/>]({{ site.baseurl }}/assets/uploads/2013/02/textarea-traversal-sc.png)

Figure 1: Screen Shot of Demo Application
