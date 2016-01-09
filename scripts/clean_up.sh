# Clean up caches and old config files left around, manage the packagelist.
clean_up() {
  echo "clean_up() function called"
  # Check cache size.
  du -sh /var/cache/apt/archives
  # Remove packages that are no longer installed from local cache.
  apt-get autoclean
  # Removes packages installed by other packages and are no longer needed.
  apt-get autoremove
  # Remove any configuration files left behind by packages, if they exist.
  dpkg --list | grep "^rc" | cut -d " " -f 3 | xargs -r dpkg --purge
  # Check that no dependencies are broken.
  apt-get check
}

clean_up || echo "clean_up() failed"
