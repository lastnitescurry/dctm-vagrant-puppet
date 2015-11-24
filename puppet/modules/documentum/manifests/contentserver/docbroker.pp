# == Define: contentserver
#
# Adds an Apache configuration file.
# http://stackoverflow.com/questions/19024134/calling-puppet-defined-resource-with-multiple-parameters-multiple-times
#
class documentum::contentserver::docbroker() {
  $ensure         = file
  $documentum     = '/u01/app/documentum'
  $version        = '7.1'
  $installer      = '/u01/app/documentum/product/7.1/install'
  $docbroker_port = 1489
  $docbroker_name = Docbroker
  $docbroker_host = $hostname

  # template(<FILE REFERENCE>, [<ADDITIONAL FILES>, ...])
  file { 'docbroker-response':
    ensure    => file,
    path      => '/home/dmadmin/sig/docbroker/docbroker.properties',
    owner     => dmadmin,
    group     => dmadmin,
    content   => template('documentum/docbroker.properties.erb'),
  }
      
  exec { "docbroker-create":
    command     => "${installer}/dm_launch_server_config_program.sh -f /home/dmadmin/sig/docbroker/docbroker.properties -r /home/dmadmin/sig/docbroker/response.properties -i Silent",
    cwd         => $installer,
    require     => [File["docbroker-response"],
                    Group["dmadmin"],
                    User["dmadmin"]],
    environment => ["HOME=/home/dmadmin",
                    "DOCUMENTUM=${documentum}",
                    "DOCUMENTUM_SHARED=${documentum}/shared",
                    "DM_HOME=${documentum}/product/${version}",
                    "ORACLE_HOME=/u01/app/oracle/product/11.2.0/xe",
                    "ORACLE_SID=XE",
                    ],
    creates     => "${documentum}/dba/dm_launch_${docbroker_name}",
    user        => dmadmin,
    group       => dmadmin,
    logoutput   => true,
    timeout     => 3000,
#    notify      => Exec["docbroker-creation-log"],
  }
  
#  exec { "docbroker-creation-log":
#    command     => "/bin/cat ${installer}/log/install.log",
#    cwd         => $installer,
#    require     => Exec["docbroker-create"],
#    logoutput   => true,
#  }
}
