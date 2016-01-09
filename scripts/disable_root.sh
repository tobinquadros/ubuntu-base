disable_root() {
  echo "disable_root() function called"
  if [ "$DISABLE_ROOT" = "true" ]; then
    # Remove the root account SSH key.
    sudo rm -rf /root/.ssh/
    # Expire the root account password.
    sudo passwd -dl root
    # Disable the actual root account
    usermod --expiredate 1 root
  else
    echo "Skipping disable_root"
  fi
}

disable_root || echo "disable_root() failed"
