#!/usr/bin/env bash
# manage_packages.sh

# ==============================================================================
# FUNCTION DEFINITIONS
# ==============================================================================

# Checks the diff between packagelist files.
function diff_packages () {
  echo "called diff_packages()"
  diff $1 $2
}

# Creates a text file (packagelist) of currently installed packages with unique
# extension of Unix epoch time for easy sortability.
function create_packagelist () {
dpkg --get-selections | grep -v deinstall > \
  $HOME/dotfiles/backups/packagelist_$(date +%s)
}

# ==============================================================================
# MAIN
# ==============================================================================

create_packagelist

