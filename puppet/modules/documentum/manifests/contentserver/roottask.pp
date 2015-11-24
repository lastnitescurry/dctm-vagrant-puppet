# == Define: contentserver
#
# Adds an Apache configuration file.
# http://stackoverflow.com/questions/19024134/calling-puppet-defined-resource-with-multiple-parameters-multiple-times
#
class documentum::contentserver::roottask() {
  $ensure = file
  $documentum = '/u01/app/documentum'
  # set defaults for file ownership/permissions
  File {
    owner => 'root',
    group => 'dmadmin',
    mode  => '6750',
  }
  file { "${documentum}/dba/dm_check_password" :
    ensure => $ensure,
    source => "${documentum}/product/7.1/install/external_apps/checkpass/dm_check_password",
  }
  file { "${documentum}/dba/dm_secure_writer" :
    ensure => $ensure,
    source => "${documentum}/product/7.1/install/external_apps/securewriter/dm_secure_writer",
  }
  file { "${documentum}/dba/dm_assume_user" :
    ensure => $ensure,
    source => "${documentum}/product/7.1/install/external_apps/assumeuser/dm_assume_user",
  }
  file { "${documentum}/dba/dm_change_password.local" :
    ensure => $ensure,
    source => "${documentum}/product/7.1/install/external_apps/changepass/dm_change_password.local",
  }
  file { "${documentum}/dba/dm_change_password.yp" :
    ensure => $ensure,
    source => "${documentum}/product/7.1/install/external_apps/changepass/dm_change_password.yp",
  }
}

