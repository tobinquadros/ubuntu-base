# Update the to newer kernel
# NOTE: the KERNEL_UPGRADE ENV VAR must be set to "true" in template.json
kernel_upgrade() {
  echo "kernel_upgrade() function called"
  if [ "$KERNEL_UPGRADE" = "true" ]; then
    sudo apt-get update
    sudo apt-get install -y linux-image-generic-lts-trusty
    sudo apt-get install -y linux-headers-generic-lts-trusty
    sudo reboot
  else
    echo "Skipping kernel_upgrade."
  fi
}

kernel_upgrade || echo "kernel_upgrade() failed"
