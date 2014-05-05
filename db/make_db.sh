#!/usr/bin/env bash
# Install and configure databases for development

# TODO: Configure databases with Upstart

# Install MongoDB
sudo apt-get install -y mongodb

# Install PostgreSQL
sudo apt-get install -y postgresql

# Install Redis
sudo apt-get install -y redis-server

# Install SQLite3
sudo apt-get install -y sqlite3
sudo apt-get install -y sqlite3-doc

