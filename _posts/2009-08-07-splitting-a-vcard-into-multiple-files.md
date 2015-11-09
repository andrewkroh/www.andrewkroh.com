---
layout: post
status: publish
published: true
title: Splitting a vCard into Multiple Files
author: Andrew Kroh
date: '2009-08-07 02:11:35 -0400'
date_gmt: '2009-08-07 06:11:35 -0400'
categories:
- uncategorized
tags:
  - perl
---
Recently I wanted to sync my contact list from Google Mail to my old Samsung
Gleam SCH-U700 via Bluetooth. From Google Mail I exported a single vCard file
containing 170 individual contacts. I tried to send the that single file to my
phone, but the end result was that the phone only imported the first contact
from the vCard. So I realized that I needed to split the vCard into multiple
files where each contained only one contact. Since vCard is a stardard format
I knew I could write a Perl script to do the work for me. Like any smart person,
I first googled the problem, but all I found was a non-working Perl script. I
fixed the script up and here it is.

Listing: vcard-splitter.pl

{% highlight perl %}
#!/usr/bin/perl
 
# Perl script for splitting a vCard with multiple contacts
# into a series of vCards named vCardXXX.vcf.
#
# Adapted from:
# http://electrons.psychogenic.com/modules/arms/art/19/MigratingPalmAddressBookstoLinuxiPAQs.php
    
my $file = shift @ARGV || die "Please pass in the file name of your consolidated vcard.";
 
die "Cannot open '$file': $!" unless (open(INFILE, "<$file"));
 
 
my $contents; # Will hold entire vcard file contents.
{
    $/ = undef;              # undef record separator
    $contents = <INFILE>;    # slurp in whole file
}
 
close(INFILE) || warn "Unable to close file: $!
 
# Create a file for each vcard found:
my $name = 0;
while ($contents =~ m/(BEGIN:VCARD.*?END:VCARD)/smg)
{
    # Contents of a single vcard file:
    my $aVcard = $1;
    
    # Output to vcardNNN.txt file:
    if (open(OUTFILE, ">vcard$name.vcf"))
    {
        print OUTFILE $aVcard;
        close(OUTFILE);
        $name++;
    } 
    else
    {
        warn "Could not write vcard$name.txt:  $!";
    }
}
{% endhighlight %}

