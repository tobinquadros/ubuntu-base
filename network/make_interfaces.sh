#!/usr/bin/env bash
# network/make_interfaces.sh

# Set the server IP to static 192.168.0.22
sudo sh -c "cat << EOF > /etc/network/interfaces
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
address 192.168.0.22
netmask 255.255.255.0
gateway 192.168.0.1
dns-search emotiva.local
dns-nameservers 192.168.0.13 192.168.0.1 8.8.8.8
EOF"

# Restart networking services
sudo /etc/init.d/networking restart

