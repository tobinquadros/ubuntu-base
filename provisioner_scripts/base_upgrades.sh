# Update the to newer kernel for docker usage or testing kernels in general.
kernel_upgrade() {
  echo "kernel_upgrade() function called"
  if [ "$KERNEL_UPGRADE" = "true" ]; then
    apt-get install -y linux-image-generic-lts-trusty
    apt-get install -y linux-headers-generic-lts-trusty
    reboot
    sleep 30 # Prevents next script from premature execution
  else
    echo "Skipping kernel_upgrade."
  fi
}

# Ensure these are available, some packages aren't default on differing images.
required_packages() {
  apt-get install -y \
    curl
}

##############################################################################
# Main
##############################################################################

apt-get update || echo "FAILED: apt-get update"
apt-get upgrade -y || echo "FAILED: apt-get upgrade"
required_packages || echo "FAILED: required_packages()"
kernel_upgrade || echo "FAILED: kernel_upgrade()"
