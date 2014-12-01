# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  # Spin up the Packer build stored in this directory.
  config.vm.box = "ubuntu"
  config.vm.box_url = "file://packer_virtualbox-iso_virtualbox.box"

  # Turn on GUI mode for debugging.
  $vb_gui = false

  # The first interface must be NAT for Vagrant to connect the first time.
  # This will be the second interface.
  config.vm.network "private_network", ip: "192.168.100.100"

  # Uncomment to share the host machine's salt-tree (read-only).
  # config.vm.synced_folder "/srv/", "/srv/", create: true, :mount_options => ["ro"]

  # Provider, match your provider's settings.
  config.vm.provider :virtualbox do |vb|
    vb.gui = $vb_gui
    vb.customize ["modifyvm", :id, "--memory", "512"]
    vb.customize ["modifyvm", :id, "--cpus", "1"]
  end
end
