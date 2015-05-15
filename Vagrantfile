# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  # GLOBAL VARIABLES
  # Turn on GUI mode for better debugging capability. To access Grub prompt in
  # Virtualbox, click inside VM window while Virtualbox splash-screen is
  # displayed, immediately hold <SHIFT> for Grub2 or <ESC> for Grub legacy.
  $vb_gui = false

  # BOX: Spin up the Packer build stored in this directory.
  # config.vm.box = "ubuntu/trusty64"
  config.vm.box = "tobinquadros/ubuntu-base"
  config.vm.box_url = "file://packer_virtualbox-iso_virtualbox.box"

  # NETWORK: The first interface must be NAT for Vagrant to connect the first time.
  # This will be the second interface.
  config.vm.network "private_network", ip: "192.168.33.33"

  # SYNCED_FOLDER: Uncomment to share the host machine's salt-tree (read-only).
  # config.vm.synced_folder "/srv/", "/srv/", create: true, :mount_options => ["ro"]

  # VIRTUALBOX: you can match cloud provider's settings.
  config.vm.provider :virtualbox do |vb|
    vb.gui = $vb_gui
    vb.customize ["modifyvm", :id, "--memory", "512"]
    vb.customize ["modifyvm", :id, "--cpus", "1"]
  end

  # DOCKER: vagrant up --provider=docker will build the dockerfile in this dir.
  # config.vm.provider :docker do |docker|
  #   docker.build_dir = "."
  # end
end
