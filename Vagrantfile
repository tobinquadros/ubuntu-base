# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  # Turn on GUI mode for better debugging capability. To access Grub prompt in
  # Virtualbox, click inside VM window while Virtualbox splash-screen is
  # displayed, immediately hold <SHIFT> for Grub2 or <ESC> for Grub legacy.
  $vb_gui = false

  # Custom Packer Ubuntu build
  config.vm.define "ubuntu", primary: true do |ubuntu|
    # Pulls from atlas.hasicorp.com/tobinquadros/ubuntu-base unless LOCAL_URL is set
    ubuntu.vm.box = "tobinquadros/ubuntu-base"

    # Use `LOCAL_URL=true vagrant up ubuntu` to test a locally built box
    if ENV["LOCAL_URL"] == "true"
      ubuntu.vm.box_url = "file://vagrant-boxes/ubuntu-base-virtualbox.box"
    end

    # Setup network
    ubuntu.vm.network "private_network", ip: "192.168.33.33"
    ubuntu.vm.network "forwarded_port", guest: 80, host: 8080, auto_correct: true
  end

  # Official Ubuntu build
  config.vm.define "xenial", autostart: false do |xenial|
    xenial.vm.box = "ubuntu/xenial64"
  end

  # Setup instance specs as needed.
  config.vm.provider :virtualbox do |vb|
    vb.gui = $vb_gui
    vb.customize ["modifyvm", :id, "--memory", "512"]
    vb.customize ["modifyvm", :id, "--cpus", "1"]
  end

end
