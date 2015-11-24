# == Define: contentserver
#
# Adds an Apache configuration file.
# http://stackoverflow.com/questions/19024134/calling-puppet-defined-resource-with-multiple-parameters-multiple-times
#
class documentum::contentserver::server() {
#  file { "cs-response-file":
#    path    => '/home/dmadmin/sig/cs/server.properties',
#    owner   => 'dmadmin',
#    group   => 'dmadmin',
#    mode    => '0644',
#    source  => 'puppet:///modules/documentum/server.properties',
#  }
  $installer  = '/home/dmadmin/sig/cs'
  $documentum = '/u01/app/documentum'
  $port       = '9080'
  $version    = '7.1'
  
  exec { "cs-installer":
    command   => "/bin/tar xvf /software/Documentum/D71/Content_Server_7.1_linux64_oracle.tar",
    cwd       => $installer,
    creates   => "${installer}/serverSetup.bin",
    user      => dmadmin,
    group     => dmadmin,
    logoutput => true,
  }

  exec { "cs-install":
    command     => "${installer}/serverSetup.bin  -r response.cs.properties -i Silent -DSERVER.DOCUMENTUM=${documentum} -DAPPSERVER.SERVER_HTTP_PORT=${port} -DAPPSERVER.SECURE.PASSWORD=dm_bof_registry",
    cwd         => $installer,
    require     => [Exec["cs-installer"],
                    Group["dmadmin"],
                    User["dmadmin"]],
    environment => ["HOME=/home/dmadmin",
                    "DOCUMENTUM=${documentum}",
                    "DOCUMENTUM_SHARED=${documentum}/shared",
                    "DM_HOME=${documentum}/product/${version}"],
#    creates     => "${installer}/response.cs.properties",
    creates     => "${documentum}/product/${version}/version.txt",
    user        => dmadmin,
    group       => dmadmin,
    logoutput   => true,
  }
}

