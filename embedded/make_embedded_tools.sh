#!/usr/bin/env bash
# make_embedded_tools.sh

# TODO: Get all the excess out of this file. Break it out to multi files.

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

# TODO: See xinetd manpage to understand setup, /etc/xinetd.conf for configuration.
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
#   $ tftp 192.168.0.254 (or tftpd IP addr)
#   tftp> get testfile
#   Sent 159 bytes in 0.0 seconds (returned from server)
#   tftp> quit
#   $ cat testfile
#

# ==============================================================================
# NFS
# ==============================================================================

# Install NFS server.
sudo apt-get install -y nfs-kernel-server

# Question: Is NFS needed for Production?
# Create Production directory if it doesn't already exist.
# Ensure directory is available and set permissions for NFS with UID/GID.
mkdir -p $HOME/Production
sudo chmod -R 777 $HOME/Production
sudo chown -R nobody:nogroup $HOME/Production
# Create Development directory if it doesn't already exist.
# Ensure directory is available and set permissions for NFS with UID/GID.
mkdir -p $HOME/Development
sudo chmod -R 777 $HOME/Development
sudo chown -R nobody:nogroup $HOME/Development

# Configure directories to be exported by adding them to /etc/exports file.
# For details see: man exports
sudo sh -c "cat << EOF > /etc/exports
/home/tobin/Production   *(ro,no_root_squash,no_all_squash,no_subtree_check)
/home/tobin/Development   *(rw,sync,no_root_squash,no_all_squash,no_subtree_check)
EOF"
sudo exportfs -a

# Start NFS
sudo service nfs-kernel-server start

# ==============================================================================
# Samba- for Windows cross environment
# ==============================================================================

# Install Samba
sudo apt-get install -y samba samba-common system-config-samba python-glade2

# Start the smbd service
sudo restart smbd
sudo restart nmbd

# This needs to go in /etc/samba/smb.conf but it can't overwrite the file.
# I would like to append it, but don't want to append it every time.
# Question: Is CFEngine3 right for this?
#
# [Production]
#   comment = Production Directories on Ubuntu
#   path = /home/tobin/Production
#   valid users = nobody
#   available = yes
#   read only = yes
#   writable = no
#   guest ok = yes
#   public = yes
#   browseable = yes
#
# [Development]
#   comment = Development Directories on Ubuntu
#   path = /home/tobin/Development
#   valid users = nobody
#   available = yes
#   read only = no
#   writable = yes
#   guest ok = yes
#   public = yes
#   browseable = yes
#

