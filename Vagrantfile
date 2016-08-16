# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  # Turn on GUI mode for better debugging capability. To access Grub prompt in
  # Virtualbox, click inside VM window while Virtualbox splash-screen is
  # displayed, immediately hold <SHIFT> for Grub2 or <ESC> for Grub legacy.
  $vb_gui = false

  # Custom packer build
  config.vm.define "custom", primary: true do |custom|
    custom.vm.box = "tobinquadros/custom"
    custom.vm.box_url = "file://vagrant-boxes/custom-virtualbox.box"
    custom.vm.network "private_network", ip: "192.168.33.34"
  end

  # Official Ubuntu build
  config.vm.define "xenial" do |xenial|
    xenial.vm.box = "ubuntu/xenial64"
    xenial.vm.network "private_network", ip: "192.168.33.33"
  end

  # Setup instance specs as needed.
  config.vm.provider :virtualbox do |vb|
    vb.gui = $vb_gui
    vb.customize ["modifyvm", :id, "--memory", "512"]
    vb.customize ["modifyvm", :id, "--cpus", "1"]
  end

end
