# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  ###
  # VARIABLES
  ###
  # $base_box = "ubuntu/trusty64"
  $base_box = "Ubuntu-14.04-Desktop-x64"
  $vb_gui = True

  config.vm.box = $base_box
  config.vm.provider :virtualbox do |vb|
    vb.gui = $vb_gui
    vb.customize ["modifyvm", :id, "--memory", "2048"]
  end
end
