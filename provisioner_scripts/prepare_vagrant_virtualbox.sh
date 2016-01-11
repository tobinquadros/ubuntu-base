# Ensure the vagrant user is ready for immediate usage by vagrant.
setup_vagrant() {
  echo "setup_vagrant() function called"
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
  sed -i s/PermitRootLogin\ yes/PermitRootLogin\ no/ /etc/ssh/sshd_config
  # Install VB guest additions
  apt-get install -y build-essential linux-headers-$(uname -r) dkms
  mount -o loop,ro /root/VBoxGuestAdditions.iso /media/cdrom
  sh /media/cdrom/VBoxLinuxAdditions.run
  umount /media/cdrom
}

# Speed up bootloading process, more verbose for virtualbox low-level debugging
setup_grub() {
  echo "setup_grub() function called"
  sed -i s/GRUB_TIMEOUT\=10/GRUB_TIMEOUT\=0/ /etc/default/grub
  sed -i s/GRUB_CMDLINE_LINUX_DEFAULT\=\"quiet\"/GRUB_CMDLINE_LINUX_DEFAULT\=\"\"/ /etc/default/grub
  update-grub
}

# Disable the root account on virtualbox
disable_root() {
  echo "disable_root() function called"
  # Remove the root account SSH key.
  rm -rf /root/.ssh/
  # Expire the root account password.
  passwd -dl root
  # Disable the account
  usermod --expiredate 1 root
}

# Prep filesystem for better compression on VM.
prep_compression() {
  echo "prep_compression() function called"
  dd if=/dev/zero of=/EMPTY bs=1M
  rm -rf /EMPTY
}

##############################################################################
# Main
##############################################################################

if [ "$PACKER_BUILDER_TYPE" = "virtualbox-iso" ]; then
  setup_vagrant || echo "FAILED: setup_vagrant()"
  setup_grub || echo "FAILED: setup_grub()"
  disable_root || echo "FAILED: disable_root()"
  prep_compression || echo "FAILED: prep_compression()"
else
  echo "Skipping prepare_vagrant_virtualbox.sh"
fi
