---
layout: post
status: publish
published: true
title: Managing a Firewall with Puppet when using Docker
excerpt: How to manage a firewall with Puppet when using docker.
author: Andrew Kroh
date: '2015-03-08 18:30:01 -0400'
date_gmt: '2015-03-08 22:30:01 -0400'
categories:
- puppet
tags: []
---
The problem with using Docker and managing your firewall with Puppet is that you
have two competing tools trying to manage the rules in the firewall. The
puppetlabs-firewall module allows you purge all unmanaged firewall chains and
rules, and if configured to do so, puppet will purge the rules added by Docker.

This is how you purge _all_ unmanaged rules:

{% highlight puppet %}
resources { 'firewall':
  purge => true,
}
{% endhighlight %}

A feature added in puppetlabs-firewall 1.3 provides a method for allowing Puppet
to selectively purge unmanaged firewall rules within a particular chain. A
`firewallchain` parameter named
[`ignore`](https://github.com/puppetlabs/puppetlabs-firewall/blob/01ba4b9c4ac291b51aeca1f1dc487e6607605e7d/lib/puppet/type/firewallchain.rb#L116)
accepts regular expressions that are to be matched against firewall rules within
that chain that are to be ignored when purging.

When the docker service is started it add iptables rules like this:

{% highlight bash %}
-A FORWARD -o docker0 -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
-A FORWARD -i docker0 ! -o docker0 -j ACCEPT
-A FORWARD -i docker0 -o docker0 -j ACCEPT
{% endhighlight %}

To configure puppetlabs-firewall to ignore the docker rules when purging you can
configure your firewallchain to ignore rules containing `"-o docker0"` and `"-i
docker0"`. It is **important** to note that you cannot purge all firewall
resources as shown above and make use of the `ignore` parameter; the
implications of this are that you lose the ability to purge unmanaged
`firewallchain`s and you must define a `firewallchain` for each chain from which
you wish to have puppet purge rules.

{% highlight puppet %}
firewallchain { 'FORWARD:filter:IPv4':
  ensure => present,
  purge  => true,
  ignore => [
    '-o docker0',
    '-i docker0',
  ],
}
{% endhighlight %}

For my projects I have created [wrapper
module](https://github.com/andrewkroh/puppet-base_firewall) around
puppetlabs-firewall that creates a firewallchain for INPUT, OUTPUT, and FORWARD
and configures each of them to purge all rules except for those containing
docker0. I am not creating any NAT rules outside of docker so I have chosen to
not manage any of the chains within the NAT table using Puppet.

#### Related Links

- [andrewkroh/base_firewall Module](https://github.com/andrewkroh/puppet-base_firewall)
- [Puppetlabs Firewall Module](https://forge.puppetlabs.com/puppetlabs/firewall)
- [MODULES-1234 - puppetlabs-firewall and Docker](https://tickets.puppetlabs.com/browse/MODULES-1234)
- [Docker Advanced Networking](https://docs.docker.com/articles/networking/ "Docker Advanced Networking")
