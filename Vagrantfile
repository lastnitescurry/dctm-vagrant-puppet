# Example 1
#
# https://github.com/rwilcox/vagrant_deep_dive
# BOX
# https://github.com/NREL/vagrant-boxes
# https://atlas.hashicorp.com/nrel/boxes/CentOS-6.6-x86_64/versions/1.0.0

# http://serverfault.com/questions/581664/how-to-set-up-datadir-when-using-hiera-with-puppet-and-vagrant
# https://github.com/stlhrt/vagrant-boxes
# https://www.virtualbox.org/manual/ch08.html#idp47384984955296
#
# https://atlas.hashicorp.com/puppetlabs/boxes/centos-7.0-64-puppet
# https://atlas.hashicorp.com/puppetlabs
#
# https://atlas.hashicorp.com/nrel/boxes/CentOS-6.6-x86_64/versions/1.0.0
# https://github.com/NREL/vagrant-boxes
# https://atlas.hashicorp.com/nrel/boxes/CentOS-6.6-x86_64
#
# GUI boxes --- 
# https://atlas.hashicorp.com/boxes/search?utf8=%E2%9C%93&sort=&provider=virtualbox&q=linux+mint
# https://atlas.hashicorp.com/npalm/boxes/mint17-amd64-cinnamon
# https://atlas.hashicorp.com/iluvatar/boxes/linuxmint-17.3
#
domain   = 'farrengold.ie'
nopuppet = 'client'

nodes = [
  { :gport => '8080', :hport => '18080', :hostname => 'client',    :ip => '192.168.100.11', :box => 'npalm/mint17-amd64-cinnamon', :ram => '2048', :cpus => '2', :desc => 'npalm/mint17-amd64-cinnamon'},
  { :gport => '8080', :hport => '8080',  :hostname => 'database',  :ip => '192.168.100.10', :box => 'nrel/CentOS-6.7-x86_64', :ram => '2048', :cpus => '2', :desc => 'Centos 6.6 - Database Server'},
  { :gport => '8080', :hport => '8081',  :hostname => 'appsservr', :ip => '192.168.100.20', :box => 'nrel/CentOS-6.7-x86_64', :ram => '1024', :cpus => '1', :desc => 'Centos 6.7 - Application Server'},
  { :gport => '9080', :hport => '19080', :hostname => 'csmaster',  :ip => '192.168.100.30', :box => 'nrel/CentOS-6.6-x86_64', :ram => '2048', :cpus => '2', :desc => 'Centos 6.6 - Content Server - Master of Puppets'},
  { :gport => '9080', :hport => '29080', :hostname => 'csnode',    :ip => '192.168.100.31', :box => 'nrel/CentOS-6.6-x86_64', :ram => '2048', :cpus => '2', :desc => 'Centos 6.6 - Content Server - EMC node creation script'},
  { :gport => '9080', :hport => '39080', :hostname => 'csmanual',  :ip => '192.168.100.32', :box => 'nrel/CentOS-6.6-x86_64', :ram => '2048', :cpus => '2', :desc => 'Centos 6.6 - Content Server - manual node'},
]

Vagrant.configure("2") do |config|
  # Update virutal box additions
#  config.vbguest.iso_path = "D:/Software/Oracle/VirtualBox/%{version}/VBoxGuestAdditions_%{version}.iso"
#  config.vbguest.iso_path = "C:\Program Files\Oracle\VirtualBox\VBoxGuestAdditions.iso"
  # do NOT download the iso file from a webserver
  config.vbguest.no_remote = true
  config.vbguest.no_install = true
  
  nodes.each do |node|
    config.vm.define node[:hostname] do |nodeconfig|
      nodeconfig.vm.box = node[:box]
      nodeconfig.vm.hostname = node[:hostname]
      nodeconfig.vm.network :private_network, ip: node[:ip]
#      nodeconfig.vm.network :public_network, ip: node[:ip]
      nodeconfig.vm.network :forwarded_port,  guest: node[:gport],  host: node[:hport]

      memory = node[:ram] ? node[:ram] : 512;
      cpus = node[:cpus] ? node[:cpus] : 1;
      desc = node[:desc] ? node[:desc] : "Please tell me what I am to be";

      nodeconfig.vm.provider :virtualbox do |vb|
        vb.customize [
          "modifyvm",      :id,
          "--cpus",        cpus.to_s,
          "--memory",      memory.to_s,
          "--name",        node[:hostname].to_s,
          "--description", desc.to_s,
          "--vram",        "256",
        ]
      end

      if 'client' != node[:hostname]
        nodeconfig.vm.provision "shell", inline: $puppet_tooling
        nodeconfig.vm.provision "puppet" do |puppet|
          puppet.manifests_path     = "puppet/manifests"
          puppet.manifest_file      = "site.pp"
          puppet.module_path        = "puppet/modules"
          puppet.hiera_config_path  = "puppet/hiera/hiera.yaml"
          puppet.working_directory  = "/tmp/vagrant-puppet"
      #    puppet.options            = "--debug --graph"
      #    puppet.options            = "--debug"
      #    puppet.options            = "--verbose --trace"
        end
      end
    end
  end

  config.vm.synced_folder("D:/Software", "/software", :mount_options => ["dmode=777","fmode=666"])
  config.vm.synced_folder("puppet/hiera", "/tmp/vagrant-puppet/hiera")

  # Reset UNIX users passwords - Just cos I can
  # https://github.com/puphpet/packer-templates/blob/master/centos-6-x86_64/http/ks.cfg
#  config.vm.provision :shell, :inline => "echo \"vagrant\"|passwd --stdin vagrant"
#  config.vm.provision :shell, :inline => "echo \"vagrant\"|passwd --stdin root"
#  config.vm.provision :shell, :inline => "gem install deep_merge"
#  config.vm.provision :shell, :inline => "echo Puppet version; puppet --version"

  $puppet_tooling = <<SCRIPT
  gem install deep_merge
  puppet module install /software/Puppet/Forge/puppetlabs-stdlib-4.9.0.tar.gz --ignore-dependencies
  puppet module install /software/Puppet/Forge/nanliu-staging-1.0.3.tar.gz    --ignore-dependencies
  puppet module install /software/Puppet/Forge/puppetlabs-concat-1.2.4.tar.gz --ignore-dependencies
  puppet module install /software/Puppet/Forge/puppetlabs-tomcat-1.3.2.tar.gz --ignore-dependencies
  puppet module install /software/Puppet/Forge/ccin2p3-etc_services-1.0.0.tar.gz --ignore-dependencies
SCRIPT


  #  config.vm.provision :shell, :inline => "puppet module install /software/Puppet/Forge/puppetlabs-stdlib "
#  config.vm.provision :shell, :inline => "puppet module install puppetlabs-tomcat"
#  config.vm.provision :shell, :inline => ""
      
end
