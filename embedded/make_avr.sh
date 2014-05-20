#!/usr/bin/env bash
# make_avr.sh

# Install Atmel AVR development environment for Ubuntu.
sudo apt-get install -y gcc-avr gdb-avr
sudo apt-get install -y avrdude avrdude-doc
sudo apt-get install -y avr-libc
sudo apt-get install -y binutils-avr

