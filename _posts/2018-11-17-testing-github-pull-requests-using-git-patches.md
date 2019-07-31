---
layout: post
title: Testing Github Pull Requests Using git Patches
excerpt: How to apply a git patch from a Github PR
published: true
author: Andrew Kroh
date: '2018-01-17 12:00:00 +0000'
date_gmt: '2018-01-17 12:00:00 +0000'
categories:
  - development
tags: []

---
Did you know that Github can provide a patch file for any pull request (PR)?
Appending `.patch` to any pull request URL will get you a patch file for the
PR.

If you want to locally test the changes provided in the PR then applying the
patch to your local repository can be a fast way to get the changes. You simply
need to download the patch with `curl` then apply it using `git`.

```
curl -L -O https://github.com/elastic/go-libaudit/pull/18.patch
git am 18.patch
```

After running those command the PR will be applied to your branch. You can see
the changes by checking the git log.

```
git log -1
```
