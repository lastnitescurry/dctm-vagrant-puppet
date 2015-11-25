# == Class: appserver
#
# Deploy documentum applications on a provisioned tomcat instance
#
define applicationserver::wdkwar (
  $war_source,
  $webapps_dir) {
  
  file { "${name}-webapp-dir":
    ensure  => directory,
    path    => "${webapps_dir}/${name}",
  }
  exec { "${name}-unzip":
    command => "/usr/bin/unzip $war_source",
    cwd     => "${webapps_dir}/${name}",
    creates => "${webapps_dir}/${name}/version.properties",
    user    => tomcat,
    group   => tomcat,
    require => File["${name}-webapp-dir"],
    notify  => File["${name}-dfc.properties"],
  }
  file { "${name}-dfc.properties":
    path    => "${webapps_dir}/${name}/WEB-INF/classes/dfc.properties",
    source  => 'puppet:///modules/applicationserver/dfc.properties',
  }
}
