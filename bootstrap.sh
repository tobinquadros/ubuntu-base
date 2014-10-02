#!/usr/bin/env sh
# bootstrap.sh

# ==============================================================================
# FUNCTION DEFINITIONS
# ==============================================================================

# If there are more than zero argruments in $@, parse them then run program.
parse_options() {
  while :
  do
    case $1 in
      --help)
        show_usage
        exit 0
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

Usage: $0 [options]

Options:
  --help              show this help menu

EOF
}

# Fetch updates for /etc/apt/sources.list package indexes.
update() {
  echo "update() function called."
  sudo apt-get -q=2 update
}

# Perform mandatory installs.
install() {
  echo "install() function called."
}

# Upgrade packages.
upgrade() {
  echo "upgrade() function called."
  sudo apt-get -q=2 upgrade
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

# ==============================================================================
# MAIN
# ==============================================================================

# Get the command line options that were passed.
parse_options $@

# Get selected updates.
update

# Run the install function.
install

# Upgrade the selected updates.
upgrade

# Clean up caches and old config files left around, manage the packagelist.
clean_up

