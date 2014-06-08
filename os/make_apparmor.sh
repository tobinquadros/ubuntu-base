#!/usr/bin/env bash
# make_apparmor.sh

# Install utils, allows admin to check for unconfined processes etc.
sudo apt-get install -y apparmor-utils

# Enable Apparmor enforce on Firefox
# See: https://help.ubuntu.com/14.04/serverguide/apparmor.html
# To disable again:
#   sudo ln -s /etc/apparmor.d/usr.bin.firefox /etc/apparmor.d/disable/
#   sudo apparmor_parser -R /etc/apparmor.d/usr.bin.firefox
sudo rm /etc/apparmor.d/disable/usr.bin.firefox
cat /etc/apparmor.d/usr.bin.firefox | sudo apparmor_parser -a

# The aa-unconfined tool uses netstat -nlp to inspect open ports, detect
# programs associated with those ports, and inspect the AppArmor profiles
# that you have loaded, then prints it to the console.
sudo aa-unconfined

