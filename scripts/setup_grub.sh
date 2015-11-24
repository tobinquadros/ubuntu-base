# Speed up the grub bootloading process, also more verbose
setup_grub() {
  echo "setup_grub() function called"
  sudo sed -i s/GRUB_TIMEOUT\=10/GRUB_TIMEOUT\=0/ /etc/default/grub
  sudo sed -i s/GRUB_CMDLINE_LINUX_DEFAULT\=\"quiet\"/GRUB_CMDLINE_LINUX_DEFAULT\=\"\"/ /etc/default/grub
  sudo update-grub
}

setup_grub || echo "setup_grub() failed"
