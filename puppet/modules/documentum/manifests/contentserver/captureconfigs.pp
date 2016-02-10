# == Define: contentserver
# 
class documentum::contentserver::captureconfigs(
  $documentum_data  = '/vagrant/repositorydata',
  $capture_dir      = 'csmaster',
  $repo_start       = 'dm_start_farrengold',
  $repo_stop        = 'dm_shutdown_farrengold'
  $server_ini       = 'server.ini'
  ) {
  
    file { 'capture-dir':
      ensure    => directory,
      path      => "${documentum_data}/${capture_dir}",
    }

    file { 'c-dfc.properties':
      path      => "${documentum_data}/${capture_dir}/dfc.properties",
      source    => '/u01/app/documentum/shared/config/dfc.properties',
      require   => File["capture-dir"]
    }
    file { 'c-server.ini':
      path      => "${documentum_data}/${capture_dir}/${server_ini}",
      source    => "/u01/app/documentum/dba/config/farrengold/${server_ini}",
      require   => File["capture-dir"]
    }
    file { 'farrengold.log':
      path      => "${documentum_data}/${capture_dir}/farrengold.log",
      source    => '/u01/app/documentum/dba/log/farrengold.log',
      require   => File["capture-dir"]
    }
    file { 'dm_start_farrengold':
      path      => "${documentum_data}/${capture_dir}/${repo_start}",
      source    => "/u01/app/documentum/dba/${repo_start}",
      require   => File["capture-dir"]
    }
    file { 'dm_shutdown_farrengold':
      path      => "${documentum_data}/${capture_dir}/${repo_stop}",
      source    => "/u01/app/documentum/dba/${repo_stop}",
      require   => File["capture-dir"]
    }
    file { 'dm_documentum_config.txt':
      path      => "${documentum_data}/${capture_dir}/dm_documentum_config.txt",
      source    => '/u01/app/documentum/dba/dm_documentum_config.txt',
      require   => File["capture-dir"]
    }
    # JMS Apps
    file { 'jms-web.xml':
      path      => "${documentum_data}/${capture_dir}/jms-web.xml",
      source    => '/u01/app/documentum/shared/jboss7.1.1/server/DctmServer_MethodServer/deployments/ServerApps.ear/DmMethods.war/WEB-INF/web.xml',
      require   => File["capture-dir"]
    }
    file { 'jms-dfc.properties':
      path      => "${documentum_data}/${capture_dir}/jms-dfc.properties",
      source    => '/u01/app/documentum/shared/jboss7.1.1/server/DctmServer_MethodServer/deployments/ServerApps.ear/APP-INF/classes/dfc.properties',
      require   => File["capture-dir"]
    }
    
    # ACS Apps
    file { 'acs-dfc.properties':
      path      => "${documentum_data}/${capture_dir}/acs-dfc.properties",
      source    => '/u01/app/documentum/shared/jboss7.1.1/server/DctmServer_MethodServer/deployments/acs.ear/lib/configs.jar/dfc.properties',
      require   => File["capture-dir"]
    }
    file { 'acs-jmx.properties':
      path      => "${documentum_data}/${capture_dir}/acs-jmx.properties",
      source    => '/u01/app/documentum/shared/jboss7.1.1/server/DctmServer_MethodServer/deployments/acs.ear/lib/configs.jar/jmx.properties',
      require   => File["capture-dir"]
    }
    file { 'acs-ucf.server.config.xml':
      path      => "${documentum_data}/${capture_dir}/acs-ucf.server.config.xml",
      source    => '/u01/app/documentum/shared/jboss7.1.1/server/DctmServer_MethodServer/deployments/acs.ear/lib/configs.jar/ucf.server.config.xml',
      require   => File["capture-dir"]
    }
    file { 'acs-acs.properties':
      path      => "${documentum_data}/${capture_dir}/acs-acs.properties",
      source    => '/u01/app/documentum/shared/jboss7.1.1/server/DctmServer_MethodServer/deployments/acs.ear/lib/configs.jar/config/acs.properties',
      require   => File["capture-dir"]
    }
    file { 'acs-acsfull.properties':
      path      => "${documentum_data}/${capture_dir}/acs-acsfull.properties",
      source    => '/u01/app/documentum/shared/jboss7.1.1/server/DctmServer_MethodServer/deployments/acs.ear/lib/configs.jar/config/acsfull.properties',
      require   => File["capture-dir"]
    }
}

