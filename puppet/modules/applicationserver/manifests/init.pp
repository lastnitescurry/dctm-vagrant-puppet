# == Class: appserver
#
# Deploy documentum applications on a provisioned tomcat instance
#
class applicationserver {

  class { 'tomcat':
    catalina_home       => '/u01/app/apache-tomcat/documentum',
    manage_user         => false,
    manage_group        => false,
  }->
  tomcat::instance { 'apache-tomcat-7.0.65':
    catalina_base       => '/u01/app/apache-tomcat/apache-tomcat-7.0.65',
    catalina_home       => '/u01/app/apache-tomcat/documentum',
    source_url          => '/software/Apache/Tomcat/apache-tomcat-7.0.65.tar.gz'
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
