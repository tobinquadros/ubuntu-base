#!/usr/bin/env bash
# make_codesourcery.sh

# Download the installer.
wget http://www.codesourcery.com/sgpp/lite/arm/portal/package4573/public/arm-none-linux-gnueabi/arm-2009q1-203-arm-none-linux-gnueabi.bin ~/Downloads/

# Switch the default shell for Ubuntu to Bash instead of Dash. Does this cause issues?
# TODO: Decide if this is worth it.
sudo rm /bin/sh
sudo ln -s /bin/bash /bin/sh

# Install 32-bit libs, required for Ubuntu 12.04+.
# For a very interesting note see: https://wiki.ubuntu.com/MultiarchSpec
apt-get install libgtk2.0-0:i386 libxtst6:i386 gtk2-engines-murrine:i386 lib32stdc++6 libxt6:i386 libdbus-glib-1-2:i386 libasound2:i386

# Create directory to hold the toolchain.
# TODO: Put this in the correct directory for the use case.
sudo mkdir -p /opt/codesourcery
sudo chmod ugo+wrx /opt/codesourcery

# Install toolchain.
chmod a+x arm-2009q1-203-arm-none-linux-gnueabi.bin
./arm-2009q1-203-arm-none-linux-gnueabi.bin
