# == Class: oracle
#
# Performs initial configuration tasks for all Vagrant boxes.
# http://www.puppetcookbook.com/posts/add-a-unix-group.html
# https://docs.puppetlabs.com/guides/techniques.html#how-can-i-ensure-a-group-exists-before-creating-a-user
# https://docs.puppetlabs.com/references/latest/type.html#package-attribute-install_options
# http://www.andrejkoelewijn.com/blog/2012/02/28/oracle-xe-on-ubuntu-using-vagrant-and-puppet
class oracle::xe::server {
  package { 'oracle-xe':
    ensure    => installed,
    provider  => rpm,
    source    => '/software/Oracle/Database/oracle-xe-11.2.0-1.0.x86_64.rpm',
  }
  ## Hiera lookups
  $http_port    = hiera('oracle::xe::server::http_port')
  $listner_port = hiera('oracle::xe::server::listner_port')
  $password     = hiera('oracle::xe::server::password')
  $dbenable     = hiera('oracle::xe::server::dbenable')

  # https://github.com/ismaild/vagrant-centos-oracle/blob/master/oracle/xe.rsp
  $xe_responses = "
ORACLE_LISTENER_PORT=$http_port
ORACLE_HTTP_PORT=$listner_port
ORACLE_PASSWORD=$password
ORACLE_CONFIRM_PASSWORD=$password
ORACLE_DBENABLE=$dbenable
  "
  
  file { "response-file":
    path    =>  "/u01/app/oracle/xe.rsp.properties",
    content =>  "$xe_responses",
  }
  file { "sql-post-file":
    path  => '/u01/app/oracle/configure.sql',
    owner => 'oracle',
    group => 'dba',
    mode  => '0755',
    source => 'puppet:///modules/oracle/configure.sql',
  }
  
  exec { "create-database":
    command   => "/etc/init.d/oracle-xe configure responseFile=/u01/app/oracle/xe.rsp.properties",
    require   => [Package["oracle-xe"],File["response-file"]],
    user      => root,
    logoutput => true,
    creates   => '/u01/app/oracle/oradata/XE/system.dbf',
   }
   
  exec { "post-db-sql":
    command     => "/u01/app/oracle/product/11.2.0/xe/bin/sqlplus system/manager < /u01/app/oracle/configure.sql",
    cwd         => "/u01/app/oracle/product/11.2.0/xe/bin",
    require     => [Exec["create-database"],File["sql-post-file"]],
    environment => [
                  "ORACLE_HOME=/u01/app/oracle/product/11.2.0/xe",
                  "ORACLE_SID=XE",
                  "NLS_LANG=AMERICAN_AMERICA.AL32UTF8",
                  "DM_HOME=${documentum}/product/${version}"
                  ],
    user        => root,
    logoutput   => true,
    subscribe   => File["sql-post-file"],
    refreshonly => true,
   }
}