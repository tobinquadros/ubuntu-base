# Speed up bootloading process, more verbose for virtualbox low-level debugging
setup_grub() {
  echo "setup_grub() function called"
  sed -i s/GRUB_TIMEOUT\=10/GRUB_TIMEOUT\=0/ /etc/default/grub
  sed -i s/GRUB_CMDLINE_LINUX_DEFAULT\=\"quiet\"/GRUB_CMDLINE_LINUX_DEFAULT\=\"\"/ /etc/default/grub
  update-grub
}

setup_grub || echo "setup_grub() failed"
