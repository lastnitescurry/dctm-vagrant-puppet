#Introduction

Documentum development environment with separate servers for database, application server and content servers. Vagrant controls Oracle Virtual Box and provisioned is done with Puppet

## Provisioned Application URLS

### Oracle XE Server
+ [Oracle XE](http://127.0.0.1:8080/apex/f?p=4950:1)

### Documentum
+ [DA - quick check test link, version.properties](http://127.0.0.1:8081/da/version.properties)
+ [DA](http://127.0.0.1:8081/da)
+ [DA](http://appsservr:8080/da)

### Jenkins
+ [Jenkins](http://127.0.0.1:8081/jenkins)
+ [Jenkins](http://appsservr:8080/jenkins)

##### Monitoring
+ [Jenkins](http://127.0.0.1:8081/jenkins/monitoring)

## Setup Requirements
1. [Vagrant](https://community.emc.com/people/aldago-zF7Lc/blog/2015/02/18/unofficial-d72-developer-edition)
1. [vagrant-vbguest plugin](https://github.com/dotless-de/vagrant-vbguest). Install command: vagrant plugin install vagrant-vbguest
1. [Oracle Virtual Box]


--------------------
# References
## Documentum

+ [(Unofficial) D7.2 Developer Edition](https://community.emc.com/people/aldago-zF7Lc/blog/2015/02/18/unofficial-d72-developer-edition)
+ [(Unofficial) D7.1 Developer Edition](https://community.emc.com/people/aldago-zF7Lc/blog/2014/01/30/unofficial-d71-developer-edition)

+ [(Official) D7.2 Developer Edition](https://community.emc.com/community/edn/documentum/blog/2015/11/21/documentum-72-developer-edition)
+ [(Official) D7.1 Developer Edition](https://community.emc.com/community/edn/documentum/blog/2014/03/20/new-documentum-developer-edition-meets-open-source)

## Puppet

+ [deep_merge gem install](http://guides.rubygems.org/rubygems-basics/#installing-gems)

## Vagrant

+ [Vagrantfile driven from config YAML file](https://github.com/openstack-dev/devstack-vagrant)
+ [Vagrant tag on vmware](http://blogs.vmware.com/openstack/tag/vagrant/)
+ [VB Guest Plugin](https://github.com/dotless-de/vagrant-vbguest) to update virtual box additions. [Raw commands](https://gist.github.com/fernandoaleman/5083680)
+ [Stock veewee boxes, modified to support Oracle XE](https://github.com/stlhrt/vagrant-boxes)
+ [How to create](https://github.com/ckan/ckan/wiki/How-to-Create-a-CentOS-Vagrant-Base-Box)
+ [Puppetlab boxes](https://github.com/puppetlabs/puppet-vagrant-boxes)
+ [VB Guest updater}(https://github.com/dotless-de/vagrant-vbguest)
+ [VMware Vagrant](http://blogs.vmware.com/openstack/tag/vagrant)

### Vagrantfile examples
+ [2 node - devstack-vagrant](https://github.com/openstack-dev/devstack-vagrant/blob/master/Vagrantfile)
+ [How we use Vagrant](http://blog.lusis.org/blog/2012/12/17/how-we-vagrant)


### Boxes
#### Server

+ [NREL GitHub](https://github.com/NREL/vagrant-boxes)
+ [NREL CentOS 6.6](https://atlas.hashicorp.com/nrel/boxes/CentOS-6.6-x86_64)

#### Client
+ [Linux Mint](https://atlas.hashicorp.com/boxes/search?utf8=%E2%9C%93&sort=&provider=virtualbox&q=linux+mint)
+ [Mint17 Cinnamon](https://atlas.hashicorp.com/npalm/boxes/mint17-amd64-cinnamon)

## Documentum

+ [JMS High Availablity Configuration pdf](https://uk.emc.com/collateral/white-papers/h12673-wp-pdf-documentum-java-method-server-high-availablity-configuration.pdf)
+ [DFC 7x and Java 8 are not compatible](https://community.emc.com/message/889230)

## Documentum and Docker

+ Andreys [scripts and ideas](https://github.com/andreybpanfilov/dctm/tree/master/docker) are awesome, the [Silent installation and Documentum](http://blog.documentum.pro/2014/08/09/docker-and-documentum-part-ii/) section of this posting was a great starter for a lot of this work
+ [Documentum xCP running in Docker containers](https://github.com/jppop/dctm-docker)

## Oracle Database XE 11.2

+ [install_oracle_11g_xe_on](http://www.davidghedini.com/pg/entry/install_oracle_11g_xe_on)
+ [installing-oracle-xe-on-centos](https://mikesmithers.wordpress.com/2015/03/01/installing-oracle-xe-on-centos)
+ [TNS Host unreachable](http://haridba7.blogspot.co.uk/2013/01/tnsdestination-host-unreachable.html)
+ [Vagrant Centos Oracle](https://github.com/ismaild/vagrant-centos-oracle/blob/master/provisioning/oracle-xe.yml)

## ELK Stack, LogStash
--------------------
+ [Consolidating-Logs-with-Logstash](http://www.linux-magazine.com/Online/Features/Consolidating-Logs-with-Logstash)
+ [elk-3-things-i-wish-id-known](http://blog.scottlogic.com/2014/12/19/elk-3-things-i-wish-id-known.html)

