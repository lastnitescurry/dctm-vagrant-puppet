# create a new run stage to ensure certain modules are included first
stage { 'pre':
  before => Stage['main']
}

# add the baseconfig module to the new 'pre' run stage
class { 'baseconfig':
  stage => 'pre'
}

# set defaults for file ownership/permissions
#File {
#  owner => 'root',
#  group => 'root',
#  mode  => '0644',
#}

# all boxes get the base config
include baseconfig

node 'database' {
  include oracle::xe::server
}
node 'csmaster' {
  include oracle::xe::client
  include documentum

  Class [ 'oracle::xe::client' ] ->
  Class [ 'documentum' ]
}
node 'csnode' {
  include oracle::xe::client
  include documentum::node

  Class [ 'oracle::xe::client' ] ->
  Class [ 'documentum::node' ]

}
node 'appsservr' {
  class { 'tomcat':
    catalina_home       => '/u01/app/apache-tomcat/documentum',
    manage_user         => false,
    manage_group        => false,
  }->
  tomcat::instance { 'apache-tomcat-7.0.65':
    catalina_base       => '/u01/app/apache-tomcat/apache-tomcat-7.0.65',
    catalina_home       => '/u01/app/apache-tomcat/documentum',
    source_url          => '/software/Apache/Tomcat/apache-tomcat-7.0.65.tar.gz'
  }->
  tomcat::service { 'default':
    catalina_base       => '/u01/app/apache-tomcat/apache-tomcat-7.0.65',
  }->
  tomcat::war { 'da.war':
    catalina_base       => '/u01/app/apache-tomcat/apache-tomcat-7.0.65',
    war_source          => '/software/Documentum/D71/da.war',
  }
}
