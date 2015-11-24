# Ensure the vagrant user is ready for immediate usage by vagrant, then exit.
setup_vagrant() {
  echo "setup_vagrant() function called"
  echo "Setting up Vagrant..."
  # Create the vagrant user
  sudo useradd --password '$6$h9l5Mhzb$dTlqr6wzzu9YrSECBHMhxLvUjcCbXu.6hYQS8o3dxlct3HhqegOJJ2gtYeRdkUCuInXe2ib/kXJF2Rji4JmGl.' \
    --user-group \
    --comment "Vagrant User" \
    --create-home \
    --shell /bin/bash \
    vagrant
  # Minimal user environment
  sudo cp /etc/skel/.* /home/vagrant/ &>/dev/null
  sed -i s/\#force_color_prompt=yes/force_color_prompt=yes/ /home/vagrant/.bashrc
  # Give password-less sudo priveledges, ensure privs are good.
  echo "vagrant ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/vagrant
  sudo chown root:root /etc/sudoers.d/vagrant
  sudo chmod 0440 /etc/sudoers.d/vagrant
  # Setup ssh for the Vagrant User.
  sudo mkdir -p --mode=0700 /home/vagrant/.ssh
  sudo wget -qO /home/vagrant/.ssh/authorized_keys https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub
  sudo chmod 0600 /home/vagrant/.ssh/authorized_keys || { echo "~/.ssh/authorized_keys error!!!"; exit 1; }
  sudo chown -R vagrant:vagrant /home/vagrant/.ssh
  sudo echo "UseDNS no" >> /etc/ssh/sshd_config
  # Install VB guest additions
  sudo apt-get -y install virtualbox-guest-utils
}

# Setup the box for a default 'vagrant' user.
setup_vagrant || echo "setup_vagrant() failed"
