# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  # Turn on GUI mode for better debugging capability. To access Grub prompt in
  # Virtualbox, click inside VM window while Virtualbox splash-screen is
  # displayed, immediately hold <SHIFT> for Grub2 or <ESC> for Grub legacy.
  $vb_gui = false

  #
  # Spin up the latest Ubuntu LTS
  #
  config.vm.define "ubuntu", autostart: false do |ubuntu|
    ubuntu.vm.box = "ubuntu/trusty64"
    ubuntu.vm.network "private_network", ip: "192.168.33.2"
  end

  #
  # Spin up the Packer builds stored in this directory.
  #
  config.vm.define "precise" do |precise|
    precise.vm.box = "tobinquadros/precise"
    precise.vm.box_url = "file://vagrant-boxes/packer_virtualbox-iso_ubuntu-server-12.04.box"
    precise.vm.network "private_network", ip: "192.168.33.3"
  end

  config.vm.define "trusty" do |trusty|
    trusty.vm.box = "tobinquadros/trusy"
    trusty.vm.box_url = "file://vagrant-boxes/packer_virtualbox-iso_ubuntu-server-14.04.box"
    trusty.vm.network "private_network", ip: "192.168.33.4"
  end

  config.vm.define "latest" do |latest|
    latest.vm.box = "tobinquadros/latest"
    latest.vm.box_url = "file://vagrant-boxes/packer_virtualbox-iso_ubuntu-server-15.10.box"
    latest.vm.network "private_network", ip: "192.168.33.5"
  end

  #
  # Match to cloud provider instance type as needed.
  #
  config.vm.provider :virtualbox do |vb|
    vb.gui = $vb_gui
    vb.customize ["modifyvm", :id, "--memory", "512"]
    vb.customize ["modifyvm", :id, "--cpus", "1"]
  end

end
