#!/usr/bin/env bash
set -e

sudo apt update
sudo apt install -y software-properties-common
sudo apt-add-repository -y ppa:ansible/ansible
sudo apt update
sudo apt install -y ansible
