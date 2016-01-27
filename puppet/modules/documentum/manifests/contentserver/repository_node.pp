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
  $documentum_data = '/vagrant/repositorydata'

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
  
  exec { "repository-create":
    command     => "${installer}/dm_launch_cfs_server_config_program.sh -f /home/dmadmin/sig/repository/repository_node.properties -r /home/dmadmin/sig/repository/response_node.properties -i Silent",
    cwd         => $installer,
    require     => [File["repository-response"],
                    File["repository-data-dir"],
                    Group["dmadmin"],
                    User["dmadmin"]],
    environment => ["HOME=/home/dmadmin",
                    "DOCUMENTUM=${documentum}",
                    "DOCUMENTUM_SHARED=${documentum}/shared",
                    "DM_HOME=${documentum}/product/${version}",
                    "ORACLE_HOME=/u01/app/oracle/product/11.2.0/xe",
                    "ORACLE_SID=XE",
                    ],
    creates     => "${documentum_data}/dba/dm_shutdown_farrengold",
    user        => dmadmin,
    group       => dmadmin,
    logoutput   => true,
    timeout     => 3000,
#    notify      => Exec["repository-create-log"],
  }
  
#  exec { "repository-create-log":
#    command     => "/bin/cat ${installer}/log/install.log",
#    cwd         => $installer,
#    require     => Exec["repository-create"],
#    logoutput   => true,
#  }
  
}
