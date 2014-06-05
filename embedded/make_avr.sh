#!/usr/bin/env bash
# make_avr.sh

# Install Atmel AVR development environment for Ubuntu.
sudo apt-get install -y gcc-avr gdb-avr
sudo apt-get install -y avrdude avrdude-doc
sudo apt-get install -y avr-libc
sudo apt-get install -y binutils-avr

## avrdude must be run as root unless udev has a rule added,
## this added a rule file but didn't seem to work. Suggestions?
# sudo touch /etc/udev/rules.d/62-usbtiny.rules
# sudo chown root:root /etc/udev/rules.d/62-usbtiny.rules
# sudo chmod 644 /etc/udev/rules.d/62-usbtiny.rules
# echo 'echo SUBSYSTEM=="usb",\ ATTR{product}=="USBtiny",\ ATTR{idProduct}=="0c9f",\ ATTRS{idVendor}=="1781",\ MODE="0660",\ GROUP="dialout" > /etc/udev/rules.d/62-usbtiny.rules' | sudo -s
