---
layout: post
status: publish
published: true
title: Migrating a CVS Repository to Git
author: Andrew Kroh
date: '2013-12-26 12:08:51 -0500'
date_gmt: '2013-12-26 16:08:51 -0500'
categories:
- uncategorized
tags:
  - development
---
So you want to take those old CVS repositories and migrate them to Git?

You can use [cvs2git](http://cvs2svn.tigris.org/cvs2git.html) to migrate your
CVS repository with history to Git. It requires direct filesystem access the CVS
repository that you wish to convert.

Fist download cvs2git, compile, and install.  

{% highlight bash %}  
svn co --username=guest --password="" http://cvs2svn.tigris.org/svn/cvs2svn/trunk cvs2svn-trunk  
cd cvs2svn-trunk  
make install  
{% endhighlight %}

Now you are ready to convert a repository's history into git fast-forward format.  

{% highlight bash %}  
mkdir -p /tmp/convert/cvs2git-tmp  
cd /tmp/convert  
cvs2git --blobfile=cvs2git-tmp/git-blob.dat --dumpfile=cvs2git-tmp/git-dump.dat --username=cvs2git /path/to/cvs/repo/component  
{% endhighlight %}

cvs2git only migrates history so you need to add all the files to Git yourself.  
  
{% highlight bash %}  
cvs co component  
cd component  
find . -type d -name 'CVS' -exec rm -rf {} \;  
git init  
git add --all  
{% endhighlight %}

Now import the history and push it all to the origin.  

{% highlight bash %}  
cat ../cvs2git-tmp/git-blob.dat ../cvs2git-tmp/git-dump.dat | git fast-import  
git remote add origin https://github.com/name/component.git  
git push origin master  
{% endhighlight %}
