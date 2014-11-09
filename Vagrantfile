# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  # Choose official ubuntu/trusty64 vagrant box. (Good for testing)
  # config.vm.box = "ubuntu/trusty64"

  # Load saved vagrant box (must have been added to box list)
  # This will be different from the box_url unless you've added the box_url to
  # vagrant already.
  config.vm.box = "ubuntu"
  config.vm.box_url = "file://packer_virtualbox-iso_virtualbox.box"

  # This is the last build that was created with: (great for validating a box)
  # $ packer build template.json

  # Turn on GUI mode for debugging.
  $vb_gui = true

  # The first interface will be NAT for Vagrant to connect the first time.
  config.vm.network "private_network", ip: "192.168.100.100"

  # Uncomment to sync the salt-tree folders.
  # config.vm.synced_folder "salt/state_tree/", "/srv/salt/", create: true
  # config.vm.synced_folder "salt/pillar_roots/", "/srv/pillar/", create: true

  # Provider
  config.vm.provider :virtualbox do |vb|
    vb.gui = $vb_gui
    vb.customize ["modifyvm", :id, "--memory", "2048"]
    vb.customize ["modifyvm", :id, "--cpus", "2"]
  end
end
