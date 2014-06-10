#!/usr/bin/env bash
# make_vmplayer.sh

# Script installs wrapper for executable to /usr/bin/vmplayer, then installs.
# This is assuming you download bundle to ~/Downloads/ directory.
sudo apt-get install -y build-essential linux-headers-$(uname -r)
cd ~/Downloads
sudo chmod +x VMware-Player*
sudo ./VMware-Player*
cd -

# To uninstall:
# sudo vmware-installer -u vmware-player
