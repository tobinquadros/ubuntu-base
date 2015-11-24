# Expire the root account.
disable_root() {
  echo "disable_root() function called"
  # Remove the root account SSH key.
  sudo rm -rf /root/.ssh/
  # Expire the root account password.
  sudo passwd -dl root
  # Disable the actual root account
  usermod --expiredate 1 root
}

disable_root || echo "disable_root() failed"
