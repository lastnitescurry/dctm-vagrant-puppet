# == Class: baseconfig
#
# Performs initial configuration tasks for all Vagrant boxes.
#
class baseconfig {

  $hosts = hiera_hash('hosts')
  create_resources('host', $hosts)

  $groups = hiera_hash('groups')
  create_resources('group', $groups)

  $users = hiera_hash('users')
  create_resources('user', $users)
  
  $packages = hiera_hash('packages')
  create_resources('package', $packages)
 
  $services = hiera_hash('services')
  create_resources('service', $services)

  $files = hiera_hash('files')
  create_resources('file', $files)
 
  $etc_services = hiera_hash('etc_services')
  create_resources('etc_services', $etc_services)
 
#  file {
#    '/home/vagrant/.bashrc':
#      owner => 'vagrant',
#      group => 'vagrant',
#      mode  => '0644',
#      source => 'puppet:///modules/baseconfig/bashrc.sh';
#  }
}
