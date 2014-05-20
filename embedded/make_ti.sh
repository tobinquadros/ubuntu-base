#!/usr/bin/env bash
# make_ti.sh

# Resolve dependencies
# sudo apt-get update
sudo apt-get install libc6:i386 libx11-6:i386 libasound2:i386 libatk1.0-0:i386 libcairo2:i386 libcups2:i386 libdbus-glib-1-2:i386 libgconf-2-4:i386 libgdk-pixbuf2.0-0:i386 libgtk-3-0:i386 libice6:i386 libncurses5:i386 libsm6:i386 liborbit2:i386 libudev1:i386 libusb-0.1-4:i386 libstdc++6:i386 libxt6:i386 libxtst6:i386 libgnomeui-0:i386 libusb-1.0-0-dev:i386 libcanberra-gtk-module:i386


# Is this correct?
# sudo apt-get install -y gcc-arm-none-eabi

# Still need to run Code Composer Studio v6 installer.
echo "You're now ready to install TI CCS v6. Please run the installer separately."
echo "use ./ccs_setup_6.x.x.xxxxx.bin (replace the x.x.xxxxx with the version number of your installer executable)."

# Go to the /ccsv6/install_scripts folder.
# sudo ./install_drivers.sh

# Setup the TI floating license server.
# See http://processors.wiki.ti.com/index.php/License_Server_Administration_for_CCS.
# Don't forget to sudo apt-get install LSB
# Get license port number from vendor daemon port in web interface.

