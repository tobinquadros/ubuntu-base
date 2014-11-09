#!/bin/bash
# bootstrap.sh
#
# This script preps Ubuntu for a Packer build.

EDITION=${EDITION:-server}

# ==============================================================================
# FUNCTION DEFINITIONS
# ==============================================================================

# Complete the installation and prepare system for usage.
clean_up() {
  echo "clean_up() function called"
  # Check cache size.
  du -sh /var/cache/apt/archives
  # Remove packages that are no longer installed from local cache.
  sudo apt-get autoclean
  # Removes packages installed by other packages and are no longer needed.
  sudo apt-get autoremove
  # Remove any configuration files left behind by packages, if they exist.
  dpkg --list |grep "^rc" | cut -d " " -f 3 | xargs -r sudo dpkg --purge
  # Check that no dependencies are broken.
  sudo apt-get check
}

# Place and erase zeros from empty space on drive. (Improves compression)
compact() {
  echo "compact() function called"
  sudo dd if=/dev/zero of=/EMPTY bs=1M
  sudo rm -rf /EMPTY
}

# Fetch updates from /etc/apt/sources.list package indexes, then upgrade packages.
upgrade() {
  echo "upgrade() function called"
  sudo apt-get update -y
  sudo apt-get upgrade -y
}

# Tested on Ubuntu 14.04
# The latest packages for Ubuntu are published in the saltstack PPA.
install_salt() {
  echo "install_salt() function called"
  if [ -z $NO_SALT ]; then
    echo "Installing Salt..."
    # Add official Salt PPA and install
    sudo add-apt-repository -y ppa:saltstack/salt
    sudo apt-get update
    sudo apt-get install -y salt-master
    sudo apt-get install -y salt-minion
    # Setup firewall for Salt-master ports 4505, 4506.
    # Test with: nmap -sS -q -p 4505-4506 salt.master.ip.addr
    sudo ufw app update Salt
    sudo ufw allow Salt
    # Ensure services are running.
    sudo service salt-master restart
    sudo service salt-minion restart
  else
    echo "Skipping Salt install."
  fi
}

# Parse argruments in $@, either --server or --desktop must be passed.
parse_options() {
  while :
  do
    case $1 in
      --help)
        show_usage
        exit 0
        ;;
      --desktop)
        EDITION=desktop
        shift
        ;;
      --server)
        EDITION=server
        shift
        ;;
      --no-salt)
        NO_SALT=true
        shift
        ;;
      --no-vagrant)
        NO_VAGRANT=true
        shift
        ;;
      ?*) # Invalid option.
        printf >&2 'WARNING: Unknown option: %s\n' "$1"
        show_usage
        exit 1
        ;;
      *) # No more options, stop while loop.
        break
        ;;
    esac
  done
}

# Show usage info.
show_usage() {
  cat <<EOF

Usage: $0 [--options]

  Defaults:
    Server edition
    Salt installed
    Vagrant setup

Options:
  --help              Show this help menu.
  --desktop           Bootstrap Ubuntu Desktop edition.
  --server            Bootstrap Ubuntu Server edition.
  --no-salt           Don't install Salt.
  --no-vagrant        Don't setup Vagrant User.

EOF
}

# Ensure the vagrant user is ready for immediate usage by vagrant.
vagrant_user() {
  echo "vagrant_user() function called"
  if [ -z $NO_VAGRANT ]; then
    echo "Setting up Vagrant User..."
    # Install VB guest additions, build-essential is preseeded.
    sudo apt-get install -y build-essential linux-headers-$(uname -r) dkms
    sudo mount -o loop VBoxGuestAdditions.iso /media/cdrom
    sudo sh /media/cdrom/VBoxLinuxAdditions.run
    sudo umount /media/cdrom
    # Allow passwordless sudo
    echo 'vagrant ALL=(ALL) NOPASSWD:ALL' > /tmp/vagrant
    sudo chown root:root /tmp/vagrant
    sudo chmod 0440 /tmp/vagrant
    sudo mv /tmp/vagrant /etc/sudoers.d/vagrant
    # Setup ssh for the Vagrant User.
    sudo mkdir -p --mode=0700 ~/.ssh
    sudo wget -qO ~/.ssh/authorized_keys https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub
    sudo chmod 0600 ~/.ssh/authorized_keys || { echo "~/.ssh/authorized_keys error!!!"; exit 1; }
    sudo chown -R vagrant:vagrant ~/.ssh
  else
    echo "Skipping Vagrant User setup."
  fi
}

# ==============================================================================
# MAIN
# ==============================================================================

# Get the command line options that were passed.
parse_options $@

# Upgrade the selected updates.
upgrade

# Setup the box for a default 'vagrant' user.
vagrant_user

# Install the salt provisioner.
install_salt

# Clean up caches and old config files left around, manage the packagelist.
clean_up

# Prep filesystem for better compression on VM.
compact

