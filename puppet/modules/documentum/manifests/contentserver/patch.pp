# == Define: contentserver
#
# Adds an Apache configuration file.
# http://stackoverflow.com/questions/19024134/calling-puppet-defined-resource-with-multiple-parameters-multiple-times
#
class documentum::contentserver::patch() {
  $installer  = '/home/dmadmin/sig/csp'
  $documentum = '/u01/app/documentum'
  $port       = '9080'
  $version    = '7.1'
  
  exec { "csp-installer":
    command   => "/bin/tar xvf /software/Documentum/D71/Patch21/CS_7.1.0210.0328_linux_ora_P21.tar.gz",
    cwd       => $installer,
    creates   => "${installer}/patch.bin",
    user      => dmadmin,
    group     => dmadmin,
    logoutput => true,
  }
  file { "csp-installer":
    path    => '/home/dmadmin/sig/csp/patch.bin',
    owner   => 'dmadmin',
    group   => 'dmadmin',
    mode    => '0744',
    require => Exec["csp-installer"]
  }  

  exec { "csp-install":
    command     => "${installer}/patch.bin LAX_VM ${documentum}/shared/java64/1.7.0_17/bin/java -r response.properties -i Silent -DUSER_SELECTED_PATCH_ZIP_FILE=CS_7.1.0210.0328_linux_ora.tar.gz",
    cwd         => $installer,
    require     => [Exec["csp-installer"],
                    File["csp-installer"],
                    Group["dmadmin"],
                    User["dmadmin"]],
    environment => ["HOME=/home/dmadmin",
                    "DOCUMENTUM=${documentum}",
                    "DOCUMENTUM_SHARED=${documentum}/shared",
                    "DM_HOME=${documentum}/product/${version}"],
    creates     => "${documentum}/patch/patch-info.xml",
    user        => dmadmin,
    group       => dmadmin,
    logoutput   => true,
  }

}

