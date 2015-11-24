# Fetch updates, then dist-upgrade.
# NOTE: the DIST_UPGRADE ENV VAR must be set to "true" in template.json
dist_upgrade() {
  echo "dist_upgrade() function called"
  if [ "$DIST_UPGRADE" = "true" ]; then
    sudo apt-get update
    sudo apt-get dist-upgrade -y
  else
    echo "Skipping dist-upgrade."
  fi
}

dist_upgrade || echo "dist_upgrade() failed"
