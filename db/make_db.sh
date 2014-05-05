#!/usr/bin/env bash
# Install and configure databases for development

# TODO: Configure databases and set launchctl keys

# Install MongoDB from homebrew
brew install mongodb
# If using homebrew configs check options in mongo shell db.serverCmdLineOpts()
# You can overwrite /usr/local/etc/mongod.conf if you want to customize.

# Install PostgreSQL from homebrew
brew install postgresql

# Install Redis from homebrew
brew install redis

# Install SQLite3 from homebrew
brew install sqlite3 --with-functions

