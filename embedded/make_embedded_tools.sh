#!/usr/bin/env bash
# make_embedded_tools.sh

# Install kernel build dependencies if not already installed.
sudo apt-get install -y libncurses5-dev gcc gcc-doc make git exuberant-ctags

# Install strace for system profiling, this belong somewhere else?
sudo apt-get install -y strace

# Install serial communication tools.
sudo apt-get install -y minicom setserial

# ==============================================================================
# TFTP Server
# ==============================================================================

# Client machine needs TFTP client installed.
# See xinetd manpage to understand setup, /etc/xinetd.conf for configuration.
sudo apt-get install -y xinetd tftpd tftp
cat << EOF /etc/xinetd.d/tftp
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
EOF

# This needs to match the server_args value.
sudo mkdir /tftpboot
sudo chmod -R 777 /tftpboot
sudo chown -R nobody /tftpboot

# This is just a testfile. Check it from client machine.
cat << EOF /tftpboot/testfile
This
is
your
testfile.
EOF

# Restart TFTPD through xinetd
sudo /etc/init.d/xinetd stop
sudo /etc/init.d/xinetd start

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
sudo apt-get install -y nfs-kernel-server

# WIP: Configure directories to be exported by adding them to /etc/exports file.
cat << EOF > /etc/exports
# Replace * with one of the hostname formats.
# Make the hostname declaration as specific as possible so unwanted systems cannot access the NFS mount.
/ubuntu  *(ro,sync,no_root_squash)
/home    *(rw,sync,no_root_squash)
EOF

# Start NFS
sudo service nfs-kernel-server start

# ==============================================================================
# Samba- specific for Windows cross-toolchain development
# ==============================================================================

# 
sudo apt-get install -y samba samba-common system-config-samba python-glade2
# WIP: start the smbd service, restart nmbd.

