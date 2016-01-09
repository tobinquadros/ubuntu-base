# Prep filesystem for better compression on VM.
compact() {
  echo "compact() function called"
  sudo dd if=/dev/zero of=/EMPTY bs=1M
  sudo rm -rf /EMPTY
}

compact || echo "compact() failed"
