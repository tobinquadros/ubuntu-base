#!/usr/bin/env bash
# Install dependencies for embedded C development

# Install TI Code Composer and dependencies
#sudo apt-get install libc6-i386 libx11-6:i386 libasound2:i386 libatk1.0-0:i386 libcairo2:i386 libcups2:i386 libdbus-glib-1-2:i386 libgconf-2-4:i386 libgdk-pixbuf2.0-0:i386 libgtk-3-0:i386 libice6:i386 libncurses5:i386 libsm6:i386 liborbit2:i386 libudev1:i386 libusb-0.1-4:i386 libstdc++6:i386 libxt6:i386 libxtst6:i386 libgnomeui-0:i386 libusb-1.0-0-dev:i386 libcanberra-gtk-module:i386

# Install kernel build dependencies if not already installed.
sudo apt-get install libncurses5-dev gcc make git exuberant-ctags

# Install virtualization tools with homebrew
# brew install libvirt
# brew install qemu

# Install AVR crosspack command-line tool, type "avr-help" in Terminal for manual.
# CrossPack for AVR Development installs into /usr/local/CrossPack-AVR-<version>
# and /usr/local/CrossPack-AVR is a symbolic link to the last version installed.
# Several versions can therefore coexist. If you want only one version,
# remove the old package from /usr/local/CrossPack-AVR-<version>.
if [[ -z $(find /usr/local/ -name "CrossPack-AVR-20131216") ]]; then
  # Install AVR Crosspack
  echo "Installing /usr/local/CrossPack-AVR-<version>"
  wget -O backups/CrossPack-AVR-20131216.dmg \
    http://www.obdev.at/downloads/crosspack/CrossPack-AVR-20131216.dmg
  hdiutil attach backups/CrossPack-AVR-20131216.dmg
  sudo installer -package /Volumes/CrossPack-AVR/CrossPack-AVR.pkg \
    -target LocalSystem
  hdiutil detach "/Volumes/CrossPack-AVR"
else
  echo "/usr/local/CrossPack-AVR-<version> is already installed."
fi
