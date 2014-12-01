#!/bin/bash
# shell_provisioner.sh
#
# This script preps Ubuntu for a Packer build.

# Default some ENV variable settings.
COMPACT=${COMPACT:-"false"}
DISABLE_ROOT=${DISABLE_ROOT:-"false"}
INSTALL_SALT=${INSTALL_SALT:-"false"}
SETUP_VAGRANT=${SETUP_VAGRANT:-"false"}

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
  if [ "$COMPACT" = "true" ]; then
    sudo dd if=/dev/zero of=/EMPTY bs=1M
    sudo rm -rf /EMPTY
  else
    echo "Skipping compact."
  fi
}

disable_root() {
  echo "disable_root() function called"
  if [ "$DISABLE_ROOT" = "true" ]; then
    # Remove the root account SSH key.
    sudo rm -rf /root/.ssh/
    # Expire the root account. (deactivate)
    sudo passwd -dl root
  else
    echo "ALERT: root account left active!!!"
  fi
}

# Tested on Ubuntu 14.04
install_salt() {
  echo "install_salt() function called"
  if [ "$INSTALL_SALT" = "true" ]; then
    echo "Installing Salt..."
    wget -O - https://bootstrap.saltstack.com | sudo sh -s -- $SALT_BOOTSTRAP_OPTIONS
    # Setup firewall for default salt-master (4505), and salt-minion (4506) ports.
    # Test with: nmap -sS -q -p 4505-4506 localhost
    # sudo ufw app update Salt
    # sudo ufw allow Salt
    # Ensure services recognize any configurations.
    sudo service salt-master restart
    sudo service salt-minion restart
  else
    echo "Skipping Salt install."
  fi
}

# Parse arguments in $@
parse_options() {
  while :
  do
    case $1 in
      -h | --help)
        show_usage
        exit 0
        ;;
      --compact)
        COMPACT="true"
        shift
        ;;
      --disable-root)
        DISABLE_ROOT="true"
        shift
        ;;
      --install-salt)
        INSTALL_SALT="true"
        shift
        ;;
      --setup-vagrant)
        SETUP_VAGRANT="true"
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

# Ensure the vagrant user is ready for immediate usage by vagrant, then exit.
setup_vagrant() {
  echo "setup_vagrant() function called"
  if [ "$SETUP_VAGRANT" = "true" ]; then
    echo "Setting up Vagrant..."
    # Create the vagrant user
    sudo useradd --password '$6$h9l5Mhzb$dTlqr6wzzu9YrSECBHMhxLvUjcCbXu.6hYQS8o3dxlct3HhqegOJJ2gtYeRdkUCuInXe2ib/kXJF2Rji4JmGl.' \
      --user-group \
      --comment "Vagrant User" \
      --create-home \
      --shell /bin/bash \
      vagrant
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
    # Install VB guest additions, build-essential is preseeded.
    sudo apt-get install -y build-essential linux-headers-$(uname -r) dkms
    sudo mount -o loop VBoxGuestAdditions.iso /media/cdrom
    sudo sh /media/cdrom/VBoxLinuxAdditions.run
    sudo umount /media/cdrom
  else
    echo "Skipping Vagrant setup."
  fi
}

# Show usage info.
show_usage() {
  cat <<EOF

Usage: $0 [--options]

  Defaults:
    Compact NOT performed
    Salt NOT installed
    Vagrant NOT setup

Options:
  --compact           Improve disk compression capability.
  --disable-root      Expire the root account (de-activate)
  --help              Show this help menu.
  --install-salt      Install salt master, minion, & ufw profile.
  --setup-vagrant     Setup machine for Vagrant User, then exit.

EOF
}

# Fetch updates from /etc/apt/sources.list package indexes, then upgrade packages.
upgrade() {
  echo "upgrade() function called"
  sudo apt-get update
  sudo apt-get dist-upgrade -y
}

# ==============================================================================
# MAIN
# ==============================================================================

# Get the command line options that were passed.
parse_options $@

# Setup the box for a default 'vagrant' user.
setup_vagrant

# Upgrade the selected updates.
upgrade

# Install Salt (optional)
install_salt

# Clean up caches and old config files left around, manage the packagelist.
clean_up

# Prep filesystem for better compression on VM.
compact

# Expire the root account.
disable_root

