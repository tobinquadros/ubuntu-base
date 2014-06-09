#!/usr/bin/env bash
# make_embedded_tools.sh

# Install kernel build tools.
sudo apt-get install -y libncurses5-dev gcc gcc-doc make git exuberant-ctags

# Install profiling tools.
sudo apt-get install -y strace

# Install serial communication tools.
sudo apt-get install -y setserial minicom

# ==============================================================================
# TFTP Server
# WIP: Can this be done with dnsmasq?
# ==============================================================================

# Client machine needs TFTP client installed.
sudo apt-get install -y xinetd tftpd tftp

# WIP: See xinetd manpage to understand setup, /etc/xinetd.conf for configuration.
sudo sh -c "cat << EOF > /etc/xinetd.d/tftp
service tftp
{
  protocol        = udp
  port            = 69
  socket_type     = dgram
  wait            = yes
  user            = nobody
  server          = /usr/sbin/in.tftpd
  server_args     = /tftpboot
  disable         = no
}
EOF"

# Make directory to match "server_args" value, set perms (nobody)
sudo mkdir /tftpboot
sudo chmod -R 777 /tftpboot
sudo chown -R nobody /tftpboot

# Restart TFTPD through xinetd
sudo /etc/init.d/xinetd stop
sudo /etc/init.d/xinetd start

# Create a testfile. (Check it from client machine.)
sudo sh -c "cat << EOF > /tftpboot/testfile
This
is
your
testfile.
EOF"
# To test TFTPD run these from another machine that can access the tftp server:
#
#   $ tftp 192.168.0.122 (or tftpd IP addr)
#   tftp> get testfile
#   Sent 159 bytes in 0.0 seconds (returned from server)
#   tftp> quit
#   $ cat testfile
#

# ==============================================================================
# NFS
# ==============================================================================

# WIP: For more info see https://help.ubuntu.com/lts/serverguide/network-file-system.html
# What is portmap for?
sudo apt-get install -y nfs-kernel-server portmap

# Ensure directory is available and set perms for nfs UID/GID
mkdir -p $HOME/XMC-1
sudo chmod -R 777 $HOME/XMC-1
sudo chown -R nobody:nogroup $HOME/XMC-1

# WIP: Configure directories to be exported by adding them to /etc/exports file.
# Create exports file
sudo sh -c "cat << EOF > /etc/exports
/home/pserver/XMC-1   *(rw,sync,no_root_squash,no_all_squash,no_subtree_check)
EOF"
sudo exportfs -a

# Start NFS
sudo service nfs-kernel-server start

# ==============================================================================
# Samba- specific for Windows cross-toolchain development
# ==============================================================================

# Install Samba
sudo apt-get install -y samba samba-common system-config-samba python-glade2

# Start the smbd service
sudo restart smbd
sudo restart nmbd

# This needs to go in /etc/samba/smb.conf but it can't overwrite the file.
# I would like to append it, but don't want to append it every time.
#
# [XMC-1]
#   comment = Production Directories on Ubuntu
#   path = /home/pserver/XMC-1
#   valid users = nobody
#   available = yes
#   read only = no
#   writable = yes
#   guest ok = yes
#   public = yes
#   browseable = yes
#

