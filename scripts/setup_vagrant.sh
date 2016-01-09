# Ensure the vagrant user is ready for immediate usage by vagrant.
setup_vagrant() {
  echo "setup_vagrant() function called"
  echo "Setting up Vagrant..."
  # Create the vagrant user
  useradd --password '$6$h9l5Mhzb$dTlqr6wzzu9YrSECBHMhxLvUjcCbXu.6hYQS8o3dxlct3HhqegOJJ2gtYeRdkUCuInXe2ib/kXJF2Rji4JmGl.' \
    --user-group \
    --comment "Vagrant User" \
    --create-home \
    --shell /bin/bash \
    vagrant
  # Minimal user environment
  cp /etc/skel/.* /home/vagrant/ &>/dev/null
  sed -i s/\#force_color_prompt=yes/force_color_prompt=yes/ /home/vagrant/.bashrc
  # Give password-less sudo priveledges, ensure privs are good.
  echo "vagrant ALL=(ALL) NOPASSWD:ALL" | tee /etc/sudoers.d/vagrant
  chown root:root /etc/sudoers.d/vagrant
  chmod 0440 /etc/sudoers.d/vagrant
  # Setup ssh for the Vagrant User.
  mkdir -p --mode=0700 /home/vagrant/.ssh
  wget -qO /home/vagrant/.ssh/authorized_keys https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub
  chmod 0600 /home/vagrant/.ssh/authorized_keys || { echo "~/.ssh/authorized_keys error!!!"; exit 1; }
  chown -R vagrant:vagrant /home/vagrant/.ssh
  echo "UseDNS no" >> /etc/ssh/sshd_config
  # Install VB guest additions
  apt-get -y install virtualbox-guest-utils
}

setup_vagrant || echo "setup_vagrant() failed"
