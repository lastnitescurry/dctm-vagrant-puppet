# == Class: oracle
#
# Performs initial configuration tasks for all Vagrant boxes.
# http://www.puppetcookbook.com/posts/add-a-unix-group.html
# https://docs.puppetlabs.com/guides/techniques.html#how-can-i-ensure-a-group-exists-before-creating-a-user
# https://docs.puppetlabs.com/references/latest/type.html#package-attribute-install_options
# http://www.andrejkoelewijn.com/blog/2012/02/28/oracle-xe-on-ubuntu-using-vagrant-and-puppet
class oracle::xe::client {
  package { 'oracle-xe':
    ensure    => installed,
    provider  => rpm,
    source    => '/software/Oracle/Database/oracle-xe-11.2.0-1.0.x86_64.rpm',
  }
  ## Hiera lookups
  $host  = hiera('oracle::xe::client::db_host')
  $port  = hiera('oracle::xe::client::db_port')

  $tnsnames_ora = "
# This file is fully managed by Puppet module: oracle::xe::client
XE =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = $host)(PORT = $port))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = XE)
    )
  )
"
  file { "oracle-xe-client-tnsnames.ora":
    path    =>  "/u01/app/oracle/product/11.2.0/xe/network/admin/tnsnames.ora",
    content =>  $tnsnames_ora,
    owner   =>  oracle,
    group   =>  dba,
    mode    =>  0755,
    require =>  Package['oracle-xe']
  }
 
}