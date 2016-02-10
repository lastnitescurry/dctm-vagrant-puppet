# == Define: contentserver
#
# Adds an Apache configuration file.
# http://stackoverflow.com/questions/19024134/calling-puppet-defined-resource-with-multiple-parameters-multiple-times
#
class documentum::contentserver::repository() {
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
    path      => '/home/dmadmin/sig/repository/repository.properties',
    owner     => dmadmin,
    group     => dmadmin,
    content   => template('documentum/repository.properties.erb'),
  }
  file { 'repository-data-dir':
    ensure    => directory,
    path      => $documentum_data,
    owner     => dmadmin,
    group     => dmadmin,
  }
  
  exec { "repository-create":
    command     => "${installer}/dm_launch_server_config_program.sh -f /home/dmadmin/sig/repository/repository.properties -r /home/dmadmin/sig/repository/response.properties -i Silent",
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
    creates     => "${documentum}/dba/dm_start_farrengold",
    user        => dmadmin,
    group       => dmadmin,
    logoutput   => true,
    timeout     => 3000,
    notify      => [File["dfc.properties"], Exec [ "r-install.log"], Exec [ "r-dmadmin.ServerConfigurator.log"]]
  }
  
  exec { "r-install.log":
    command     => "/bin/cat ${installer}/logs/install.log",
    cwd         => $installer,
    logoutput   => true,
  }
  exec { "r-dmadmin.ServerConfigurator.log":
    command     => "/bin/cat ${installer}/dmadmin.ServerConfigurator.log",
    cwd         => $installer,
    logoutput   => true,
  }
  
  file { 'dfc.properties':
    ensure    => file,
    path      => '/vagrant/repositorydata/dfc.properties',
    owner     => dmadmin,
    group     => dmadmin,
    source    => '/u01/app/documentum/shared/config/dfc.properties',
  }
}
