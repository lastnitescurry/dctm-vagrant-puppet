# == Class: appserver
#
# Deploy documentum applications on a provisioned tomcat instance
#
class applicationserver {
  $catalina_home = '/u01/app/apache-tomcat/apache-tomcat-7.0.65'
  
  class { 'tomcat':
    catalina_home  => $catalina_home,
    manage_user    => false,
    manage_group   => false,
  }~>
  tomcat::instance { 'apache-tomcat-7.0.65':
    catalina_base  => $catalina_home,
    catalina_home  => $catalina_home,
    source_url     => '/software/Apache/Tomcat/apache-tomcat-7.0.65.tar.gz',
  }

  file { 'catalina.properties':
    path    => '/u01/app/apache-tomcat/apache-tomcat-7.0.65/conf/catalina.properties',
    source  => 'puppet:///modules/applicationserver/catalina.properties',
    owner   => 'tomcat',
    group   => 'tomcat',
    mode    => '0644',
    require => Tomcat::Instance['apache-tomcat-7.0.65'],
  }

#  }->
#  tomcat::service { 'default':
#    catalina_base       => '/u01/app/apache-tomcat/apache-tomcat-7.0.65',
#  }->
#  tomcat::war { 'da.war':
#    catalina_base       => '/u01/app/apache-tomcat/apache-tomcat-7.0.65',
#    war_source          => '/software/Documentum/D71/da.war',
#  }
}
