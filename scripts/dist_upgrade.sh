# Fetch updates, then dist-upgrade.
# NOTE: the DIST_UPGRADE ENV VAR must be set to "true" in template.json
dist_upgrade() {
  echo "dist_upgrade() function called"
  if [ "$DIST_UPGRADE" = "true" ]; then
    apt-get update -y
    apt-get dist-upgrade -y
  else
    echo "Skipping dist_upgrade."
  fi
}

dist_upgrade || echo "dist_upgrade() failed"
