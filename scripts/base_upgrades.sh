# Update the to newer kernel for docker usage or testing kernels in general.
kernel_upgrade() {
  echo "kernel_upgrade() function called"
  if [ "$KERNEL_UPGRADE" = "true" ]; then
    sudo apt-get install -y linux-image-generic-lts-trusty
    sudo apt-get install -y linux-headers-generic-lts-trusty
    sudo reboot
  else
    echo "Skipping kernel_upgrade."
  fi
}

sudo apt-get update || echo "apt-get update failed"
kernel_upgrade || echo "kernel_upgrade() failed"
sudo apt-get upgrade -y || echo "apt-get upgrade failed"
