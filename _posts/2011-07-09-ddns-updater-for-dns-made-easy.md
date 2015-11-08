---
layout: post
status: publish
published: true
title: DDNS Updater for DNS Made Easy
author: Andrew Kroh
date: '2011-07-09 12:00:03 -0400'
date_gmt: '2011-07-09 16:00:03 -0400'
categories:
- Categories
tags: []
comments: []
---
The problem with hosting a domain on a dynamic IP is that when your IP address changes your domain becomes inaccessible until you update the DNS record with your new IP. Hosting a domain on a dynamic IP address can be done easily if you use DDNS (Dynamic Domain Name Service) and can afford a few minutes of downtime. DNS records can be automatically updated via DDNS when the server's IP address changes.

DNS Made Easy has been handling DNS for my domains since 2004. I have written a tool in Java for performing secure DDNS updates to their servers when your IP address changes. It works by making a HTTP request to a server on the public internet that echos back the requester's IP address as seen by the server; this is what allows the tool to work behind NAT. Then it compares this IP address to the address returned during the last call, and only if they are different will it make a secure request to update the DDNS record.

This tool was written to be run periodically by some form of scheduler: crontab or Windows scheduled tasks.

For all the details head on over to GitHub and see [dns-made-easy-updater](https://github.com/andrewkroh/dns-made-easy-updater).
