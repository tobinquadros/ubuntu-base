#!/usr/bin/env bash
# bootstrap.sh

unset edition
unset verify
# ==============================================================================
# FUNCTION DEFINITIONS
# ==============================================================================

# If there are more than zero argruments in $@, parse them then run program.
parse_options() {
  # Parse command line args
  while :
  do
    case $1 in
      --help)
        show_usage
        exit 0
        ;;
      --desktop)
        edition=desktop
        shift
        ;;
      --server)
        edition=server
        shift
        ;;
      -y | --yes)
        verify=true
        shift
        ;;
      ?*) # Invalid option.
        printf >&2 'WARNING: Unknown option: %s\n' "$1"
        show_usage
        exit 1
        ;;
      *) # No more options, stop while loop.
        if [[ -z $edition ]]; then
          echo; echo "You must choose an edition!"
          show_usage
          exit 1
        fi
        break
        ;;
    esac
  done
}

# Show usage info.
show_usage() {
  cat <<EOF

Usage: $0 [--option]

Options:
  --help              Show this help menu.
  --desktop           Bootstrap Ubuntu Desktop edition.
  --server            Bootstrap Ubuntu Server edition.
  --yes | -y          Skip verification and just run script.

EOF
}

# Perform mandatory installs.
install() {
  echo "install() function called"
  if [[ $edition = desktop ]]; then
    echo 'Installing desktop edition'
  elif [[ $edition = server ]]; then
    echo 'Installing server edition'
  else
    echo "Something is wrong"
    exit 1
  fi
}

# Fetch updates for /etc/apt/sources.list package indexes, then upgrade packages.
upgrade() {
  echo "upgrade() function called"
  sudo apt-get update
  sudo apt-get upgrade
}

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

verify() {
  if [[ -z $verify ]]; then
    echo "I'm ready to bootstrap your system."
    read -p "Are you sure? (y/n) " -n 1; echo
    if [[ $REPLY =~ [Yy] ]]; then
      echo "running bootstrap.sh for Ubuntu $edition edition."
    else
      echo; echo "Come back when you change your mind :)"; echo
      exit 0
    fi
  else
    echo "running bootstrap.sh for Ubuntu $edition edition."
  fi
}

# Place and erase zeros from empty space. (Improves compression)
compact() {
  echo "compact() function called"
  dd if=/dev/zero of=/EMPTY bs=1M
  sudo rm -rf /EMPTY
}

# ==============================================================================
# MAIN
# ==============================================================================

# Get the command line options that were passed.
parse_options $@

# Ensure bootstrap is ready to run
verify

# Upgrade the selected updates.
upgrade

# Run the install function.
# install

# Clean up caches and old config files left around, manage the packagelist.
# clean_up

# Prep filesystem for better compression on VM.
# compact
