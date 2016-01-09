# Update the to newer kernel for docker usage or testing kernels in general.
kernel_upgrade() {
  echo "kernel_upgrade() function called"
  if [ "$KERNEL_UPGRADE" = "true" ]; then
    apt-get install -y linux-image-generic-lts-trusty
    apt-get install -y linux-headers-generic-lts-trusty
    reboot
  else
    echo "Skipping kernel_upgrade."
  fi
}

apt-get update || echo "apt-get update failed"
kernel_upgrade || echo "kernel_upgrade() failed"
apt-get upgrade -y || echo "apt-get upgrade failed"
