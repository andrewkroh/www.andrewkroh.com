---
layout: post
status: publish
published: true
title: Configuring Cisco ASA SSL Ciphers
author: Andrew Kroh
date: '2015-03-06 11:49:28 -0500'
date_gmt: '2015-03-06 15:49:28 -0500'
categories:
  - security
tags: []
comments: []
---
To protect against SSL vulnerabilities it is important to disable SSLv3 and
weak ciphers on your cisco ASA device.

To enumerate the ciphers supported by the device I use an openssl wrapper
script called [cipherscan](https://github.com/jvehent/cipherscan) that is
available on github. On a default Cisco ASA setup here is what ciphers are
available.

{% highlight bash %}
bash-4.3$ ./cipherscan sslvpn.example.com
.......
Target: sslvpn.example.com:443

prio  ciphersuite         protocols    pfs_keysize
1     RC4-SHA             SSLv3,TLSv1
2     DHE-RSA-AES128-SHA  TLSv1        DH,1024bits
3     DHE-RSA-AES256-SHA  TLSv1        DH,1024bits
4     AES128-SHA          SSLv3,TLSv1
5     AES256-SHA          SSLv3,TLSv1
6     DES-CBC3-SHA        SSLv3,TLSv1

Certificate: UNTRUSTED, 2048 bit, sha256WithRSAEncryption signature
TLS ticket lifetime hint: None
OCSP stapling: not supported
Server side cipher ordering
{% endhighlight %}


To change the supported protocols and ciphers, login to the Cisco ASA via SSH.
You can list the current SSL configuration with `show ssl` and then make the required changes.

You should disable SSLv3 due to the POODLE vulnerability. And you should verify
that you are using strong ciphers. I prefer to use ciphers that support PFS, but
the Cisco AnyConnect IOS app for the SSL VPN
[does not support](http://www.cisco.com/c/en/us/td/docs/security/vpn_client/anyconnect/anyconnect30/administration/guide/anyconnectadmin30/acmobiledevices.html#pgfId-1051726)
the PFS ciphers so I had to include aes256-sha1 and aes128-sha1.

{% highlight bash %}
asa5505(config)# ssl client-version tlsv1-only  
asa5505(config)# ssl server-version tlsv1  
asa5505(config)# ssl encryption dhe-aes256-sha1 dhe-aes128-sha1 aes256-sha1 aes128-sha1
asa5505# show ssl  
Accept connections using SSLv2 or greater and negotiate to TLSv1  
Start connections using TLSv1 only and negotiate to TLSv1 only  
Enabled cipher order: dhe-aes256-sha1 dhe-aes128-sha1 aes256-sha1 aes128-sha1  
{% endhighlight %}

And finally verify the changes using cipherscan.

{% highlight bash %}
bash-4.3$ ./cipherscan sslvpn.example.com  
...  
Target: sslvpn.example.com:443

prio  ciphersuite         protocols  pfs_keysize  
1     DHE-RSA-AES256-SHA  TLSv1      DH,1024bits  
2     DHE-RSA-AES128-SHA  TLSv1      DH,1024bits  
3     AES256-SHA          TLSv1  
4     AES128-SHA          TLSv1

Certificate: UNTRUSTED, 2048 bit, sha256WithRSAEncryption signature  
TLS ticket lifetime hint: None  
OCSP stapling: not supported  
Server side cipher ordering  
{% endhighlight %}
