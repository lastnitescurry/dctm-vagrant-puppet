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
  include applicationserver
}
