# == Define: contentserver
#
# Adds an Apache configuration file.
# http://stackoverflow.com/questions/19024134/calling-puppet-defined-resource-with-multiple-parameters-multiple-times
#
class documentum::contentserver::repository_node() {
  $ensure          = 'file'
  $documentum      = '/u01/app/documentum'
  $version         = '7.1'
  $installer       = '/u01/app/documentum/product/7.1/install'
  $docbroker_port  = '1489'
  $docbroker_name  = 'Docbroker'
  $docbroker_host  = $hostname
  $documentum_data = '/vagrant/repositorydata/farrengold'

  # template(<FILE REFERENCE>, [<ADDITIONAL FILES>, ...])
  file { 'repository-response':
    ensure    => file,
    path      => '/home/dmadmin/sig/repository/repository_node.properties',
    owner     => dmadmin,
    group     => dmadmin,
    content   => template('documentum/repository_node.properties.erb'),
  }
  file { 'repository-data-dir':
    ensure    => directory,
    path      => $documentum_data,
    owner     => dmadmin,
    group     => dmadmin,
  }
  file { 'dfc.properties.from.master':
    ensure    => file,
    path      => '/u01/app/documentum/shared/config/dfc.properties',
    owner     => dmadmin,
    group     => dmadmin,
    source    => '/vagrant/repositorydata/dfc.properties',
  }
  
  exec { "repository-create":
    command     => "${installer}/dm_launch_cfs_server_config_program.sh -f /home/dmadmin/sig/repository/repository_node.properties -r /home/dmadmin/sig/repository/response_node.properties -i Silent",
    cwd         => $installer,
    require     => [File["repository-response"],
                    File["repository-data-dir"],
                    File["dfc.properties.from.master"],
                    Group["dmadmin"],
                    User["dmadmin"]],
    environment => ["HOME=/home/dmadmin",
                    "DOCUMENTUM=${documentum}",
                    "DOCUMENTUM_SHARED=${documentum}/shared",
                    "DM_HOME=${documentum}/product/${version}",
                    "ORACLE_HOME=/u01/app/oracle/product/11.2.0/xe",
                    "ORACLE_SID=XE",
                    ],
    creates     => "${documentum}/dba/dm_shutdown_farrengold_farrengold",
    user        => dmadmin,
    group       => dmadmin,
    logoutput   => true,
    timeout     => 3000,
#    notify      => Exec["repository-create-log"],
  }
  # /u01/app/documentum/dba/config/farrengold
#  exec { "repository-create-log":
#    command     => "/bin/cat ${installer}/log/install.log",
#    cwd         => $installer,
#    require     => Exec["repository-create"],
#    logoutput   => true,
#  }
  
  # Convert Node from file serving content server to handle user sessions also 
  exec { "content-server-stop":
    command     => "${documentum}/dba/dm_shutdown_farrengold_farrengold",
    cwd         => "${documentum}/dba",
    require     => Exec["repository-create"],
    environment => ["HOME=/home/dmadmin",
                    "DOCUMENTUM=${documentum}",
                    "DOCUMENTUM_SHARED=${documentum}/shared",
                    "DM_HOME=${documentum}/product/${version}",
                    "ORACLE_HOME=/u01/app/oracle/product/11.2.0/xe",
                    "ORACLE_SID=XE",
                    ],
    user        => dmadmin,
    group       => dmadmin,
    logoutput   => true,
    timeout     => 3000,
  }
  exec { "content-server-convert-to-user-session-handler":
    command     => "/bin/sed -in-place '/proximity=90/d' server_${hostname}_farrengold.ini",
    cwd         => "${documentum}/dba/config/farrengold",
    require     => Exec["content-server-stop"],
    user        => dmadmin,
    group       => dmadmin,
    logoutput   => true,
    timeout     => 3000,
  }
  exec { "content-server-start":
    command     => "${documentum}/dba/dm_start_farrengold_farrengold",
    cwd         => "${documentum}/dba",
    require     => Exec["content-server-convert-to-user-session-handler"],
    environment => ["HOME=/home/dmadmin",
                    "DOCUMENTUM=${documentum}",
                    "DOCUMENTUM_SHARED=${documentum}/shared",
                    "DM_HOME=${documentum}/product/${version}",
                    "ORACLE_HOME=/u01/app/oracle/product/11.2.0/xe",
                    "ORACLE_SID=XE",
                    ],
    user        => dmadmin,
    group       => dmadmin,
    logoutput   => true,
    timeout     => 3000,
  }
}
