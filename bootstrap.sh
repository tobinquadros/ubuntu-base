#!/bin/bash
#
# This script preps Ubuntu for a Packer build.

# Default some ENV variable settings.
COMPACT=${COMPACT:-"false"}
DISABLE_ROOT=${DISABLE_ROOT:-"false"}
DIST_UPGRADE=${DIST_UPGRADE:-"false"}
INSTALL_CHEF_CLIENT=${INSTALL_CHEF_CLIENT:-"false"}
INSTALL_SALT=${INSTALL_SALT:-"false"}
SETUP_GRUB=${SETUP_GRUB:-"false"}
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
  dpkg --list | grep "^rc" | cut -d " " -f 3 | xargs -r sudo dpkg --purge
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
    # Expire the root account password.
    sudo passwd -dl root
    # Disable the actual root account
    # usermod --expiredate 1 root
  else
    echo "ALERT: root account left active!!!"
  fi
}

# Fetch updates from /etc/apt/sources.list package indexes, then APT dist-upgrade packages.
dist_upgrade() {
  echo "dist_upgrade() function called"
  if [ "$DIST_UPGRADE" = "true" ]; then
    sudo apt-get update
    sudo apt-get dist-upgrade -y
  else
    echo "Skipping dist-upgrade."
  fi
}

# Tested on Ubuntu 14.04
install_chef_client() {
  echo "install_chef_client() function called"
  if [ "$INSTALL_CHEF_CLIENT" = "true" ]; then
    echo "Installing Chef client..."
    wget -O - https://opscode.com/chef/install.sh | sudo bash
  else
    echo "Skipping Chef client install."
  fi
}

# Tested on Ubuntu 14.04
install_salt() {
  echo "install_salt() function called"
  if [ "$INSTALL_SALT" = "true" ]; then
    echo "Installing Salt..."
    wget -O - http://bootstrap.saltstack.com | sudo sh -s -- $SALT_BOOTSTRAP_OPTIONS
  else
    echo "Skipping Salt install."
  fi
}

# Parse arguments in $@.
parse_options() {
  for arg in "$@"; do
    case $arg in
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
      --dist-upgrade)
        DIST_UPGRADE="true"
        shift
        ;;
      --install-chef-client)
        INSTALL_CHEF_CLIENT="true"
        shift
        ;;
      --install-salt)
        INSTALL_SALT="true"
        shift
        ;;
      --salt-bootstrap-args=*)
        SALT_BOOTSTRAP_OPTIONS="${arg#*=}"
        ;;
      --setup-grub)
        SETUP_GRUB="true"
        shift
        ;;
      --setup-vagrant)
        SETUP_VAGRANT="true"
        shift
        ;;
      -a | --all)
        COMPACT="true"
        DISABLE_ROOT="true"
        DIST_UPGRADE="true"
        INSTALL_CHEF_CLIENT="true"
        INSTALL_SALT="true"
        SETUP_GRUB="true"
        SETUP_VAGRANT="true"
        echo "Running all options..."
        shift
        ;;
      ?*) # Invalid option.
        echo "WARNING: Unknown option: $arg"
        show_usage
        exit 1
        ;;
      *) # No more options, stop while loop.
        break
        ;;
    esac
  done
}

# Speed up the grub bootloading process, also more verbose
setup_grub() {
  echo "setup_grub() function called"
  if [ "$SETUP_GRUB" = "true" ]; then
    sudo sed -i s/GRUB_TIMEOUT\=10/GRUB_TIMEOUT\=0/ /etc/default/grub
    sudo sed -i s/GRUB_CMDLINE_LINUX_DEFAULT\=\"quiet\"/GRUB_CMDLINE_LINUX_DEFAULT\=\"\"/ /etc/default/grub
    sudo update-grub
  else
    echo "Skipping grub configuration setup."
  fi
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
    # Install VB guest additions, build-essential should already be preseeded.
    sudo apt-get install -y build-essential linux-headers-$(uname -r) dkms
    sudo mount -o loop,ro /root/VBoxGuestAdditions.iso /media/cdrom
    sudo sh /media/cdrom/VBoxLinuxAdditions.run
    sudo umount /media/cdrom
  else
    echo "Skipping Vagrant setup."
  fi
}

# Show usage info.
show_usage() {
  cat <<EOF

USAGE: $0 [--options]

OPTIONS:
  --compact                 Improve disk compression capability
  --disable-root            Disable the root account password
  --dist-upgrade            Perform APT dist-upgrade
  --help                    Show this help menu
  --install-chef-client     Install Chef client
  --install-salt            Install Salt
  --salt-bootstrap-args=ARG Agruments for salt-bootstrap.sh
                            See: https://github.com/saltstack/salt-bootstrap
  --setup-grub              Setup more verbose Grub2 bootloader configuration
  --setup-vagrant           Setup a proper Vagrant User

DEFAULTS:
  Compact NOT performed
  Root password NOT disabled
  APT dist-upgrade NOT performed
  Chef client NOT installed
  Salt NOT installed
  Verbose Grub NOT setup
  Vagrant NOT setup

EOF
}

# ==============================================================================
# MAIN
# ==============================================================================

# Get the command line options that were passed.
parse_options "$@"

# APT dist-upgrade the system.
dist_upgrade

# Setup the box for a default 'vagrant' user.
setup_vagrant

# Install Chef client
install_chef_client

# Install Salt
install_salt

# Clean up caches and old config files left around, manage the packagelist.
clean_up

# Set faster Grub2 configurations
setup_grub

# Prep filesystem for better compression on VM.
compact

# Expire the root account.
disable_root

