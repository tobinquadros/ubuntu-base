# Clean up caches and old config files left around, manage the packagelist.
apt_clean_up() {
  echo "apt_clean_up() function called"
  # Check cache size.
  du -sh /var/cache/apt/archives
  # Remove packages that are no longer installed from local cache.
  apt-get autoclean
  # Remove any configuration files left behind by packages, if they exist.
  dpkg --list | grep "^rc" | cut -d " " -f 3 | xargs -r dpkg --purge
  # Check that no dependencies are broken.
  apt-get check
}

##############################################################################
# Main
##############################################################################

apt_clean_up || echo "FAILED: apt_clean_up()"
