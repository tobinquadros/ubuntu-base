#!/usr/bin/env bash

# updates
sudo apt-get update
sudo apt-get upgrade -y

sudo apt-get install -y \
  bcmwl-kernel-source \ # broadcom wifi adapters
  git
