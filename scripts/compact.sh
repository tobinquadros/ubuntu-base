# Prep filesystem for better compression on VM.
compact() {
  echo "compact() function called"
  dd if=/dev/zero of=/EMPTY bs=1M
  rm -rf /EMPTY
}

compact || echo "compact() failed"
