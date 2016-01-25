---
layout: post
status: publish
published: true
title: Running Jenkins using SMF on Solaris 11
author: Andrew Kroh
date: '2011-06-28 01:16:34 -0400'
date_gmt: '2011-06-28 05:16:34 -0400'
categories:
- Solaris
tags:
- solaris11
---

Jenkins (formerly known as Hudson) is a continuous integration tool. Installing
Jenkins as a daemon service on Solaris 11 is pretty simple. Below are the steps
I took to get it up and running using SMF in Solaris 11. SMF or Service
Management Facility is the default way to manage services in Solaris 10 and 11.

#### Create New User to Run Jenkins

```
groupadd jenkins
useradd -g jenkins -d /export/home/jenkins -m -s /bin/bash jenkins
passwd jenkins
```

Configure the User’s Environment

```
sudo su - jenkins
mkdir workspace
wget http://mirrors.jenkins-ci.org/war-stable/latest/jenkins.war
echo source .bashrc > .bash_profile
```

Create a .bashrc with the appropriate settings for your jenkins user.

{% highlight bash %}
# Define default prompt to <username>@<hostname>:<path><"($|#) ">
# and print '#' for user "root" and '$' for normal users.
#
typeset +x PS1="\u@\h:\w\\$ "
alias l='ls -lah'
alias cdh='cd ~'

# CVS over SSH Configuration (assuming local server)
host=`hostname`
export CVS_RSH=ssh
export CVSROOT=:ext:jenkins@$host:/var/cvs

# Gradle Options
GRADLE_OPTS="-Dorg.gradle.daemon=true"
{% endhighlight %}

Create a start_jenkins.sh script.

{% highlight bash %}
#!/bin/sh
source /export/home/jenkins/.bashrc
HTTP_HOST="127.0.0.1"
HTTP_PORT="7777"

export JENKINS_HOME=/export/home/jenkins/workspace

java -Dmail.smtp.starttls.enable=true -jar /export/home/jenkins/jenkins.war --prefix=/jenkins --httpListenAddress=$HTTP_HOST --httpPort=$HTTP_PORT
{% endhighlight %}

Add execute permissions to the new script.

{% highlight bash %}
chmod a+x start_jenkins.sh
{% endhighlight %}


#### Configure SSH to allow CVS only for Jenkins

Generate a SSH key for jenkins.

{% highlight bash %}
cd ~/.ssh
ssh-keygen -t dsa
{% endhighlight %}

Append the contents of id_dsa.pub to the ~/.ssh/authorized_keys2 file on the system
that you want to allow you to log in to.

Add `command="/usr/bin/cvs server",no-port-forwarding,no-X11-forwarding,no-agent-forwarding"`
to the beginning of the line you just appended to limit the commands that Jenkins can
execute when SSH’ing to the server.

Test your SSH connection once so that you can accept the server’s key or else
Jenkins will hang on the first CVS checkout.


#### Configure SMF to Start Jenkins as a Service

You need to load a manifest file into SMF that tells it how to run Jenkins.
Place the following manifest file in `/var/svc/manifest/application` and then
load it into SMF using svccfg.

Listing: `/var/svc/manifest/application/jenkins.xml`

{% highlight xml %}
<?xml version='1.0'?>

<!DOCTYPE service_bundle SYSTEM '/usr/share/lib/xml/dtd/service_bundle.dtd.1'>

<service_bundle type="manifest" name="Jenkins">
    <service name="application/jenkins" type="service" version="1">
       <create_default_instance enabled="false"/>
       <single_instance/>

       <method_context>
           <method_credential user='jenkins' group='jenkins'/>

           <method_environment>
               <envvar name='PATH' value='/usr/bin:/usr/local/bin'/>
           </method_environment>
       </method_context>

       <exec_method type="method" name="start" exec="/export/home/jenkins/start_jenkins.sh" timeout_seconds="0"/>

       <exec_method type="method" name="stop" exec=":kill -TERM" timeout_seconds="30"/>

       <property_group name='startd' type='framework'>
           <propval name='duration' type='astring' value='child'/>
       </property_group>

       <stability value="Evolving"/>

       <template>
           <common_name>
               <loctext xml:lang='C'>Jenkins Continuous Build Server</loctext>
           </common_name>

           <documentation>
               <doc_link name='jenkins-ci.org' uri='http://jenkins-ci.org/'/>
           </documentation>
       </template>
    </service>
</service_bundle>
{% endhighlight %}

Now with the manifest file on your system. It’s time to load it into SMF.

{% highlight bash %}
svcadm restart svc:/system/manifest-import
svcadm enable jenkins
{% endhighlight %}

You can verify that it started by running this command and checking the state.

{% highlight bash %}
$ svcs -l jenkins
fmri svc:/application/jenkins:default
name Jenkins Continuous Build Server
enabled true
state online
next_state none
state_time June 28, 2011 09:06:45 PM EDT
logfile /var/svc/log/application-jenkins:default.log
restarter svc:/system/svc/restarter:default
contract_id 7207
{% endhighlight %}

If you need to debug something you can have a look at the log file for your
jenkins service at `/var/svc/log/application-jenkins:default.log`.

#### Bonus: Running Jenkins Behind Apache using Reverse Proxy

I already have a web service running on port 80, and I wanted to be able to
access Jenkins through that port. To do this I added a reverse proxy in Apache.
If you have any access controls in your apache configuration then its important
that you set the host address to 127.0.0.1 so that someone can’t go around your
proxy and hit Jenkins directly. Add the following to your httpd.conf to be able
to access Jenkins.

{% highlight apache %}
# Reverse proxy to Jenkins:
ProxyPass /jenkins http://localhost:7777/jenkins
ProxyPassReverse /jenkins http://localhost:7777/jenkins

# Allow access to this proxy to everyone:
<Proxy http://localhost:7777/jenkins*>
    Order deny,allow
    Allow from all
</Proxy>
{% endhighlight %}
