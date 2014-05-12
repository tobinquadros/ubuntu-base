#!/usr/bin/env bash
# install.sh

# TODO: Clean up the confirm task and logic.

# ==============================================================================
# FUNCTION DEFINITIONS
# ==============================================================================

# Show usage info.
function show_usage() {
  cat <<EOF

Usage: $0 [options] [file ...]

Options:
  --force-all     Install everything, no confirmation.
  --help          Show this help menu.

EOF
}

# Check script is run from dotfiles directory
function check_directories() {
  if [[ ! "$PWD/install.sh" -ef "$0" ]]; then
    printf "\n"
    echo "Please run './install.sh' from $HOME/dotfiles/ root folder."
    printf "\n"
    exit 1
  fi
  if [ ! -d backups/ ]; then
    echo "./backups/ directory not found"
    mkdir -v backups
  fi
}

# Get OS Version
function get_os_version() {
  if [[ $(lsb_release -d) == "Description:	Ubuntu 14.04 LTS" ]]; then
    echo "You're running Ubuntu 14.04 LTS, that's a good start."
  else
    echo "Your operating system may not be supported, please see the README.md file in this directory."
    exit 1
  fi
}

# Install confirmed software and files.
function install() {
  echo "Install running..."

  # TODO: See apt_preferences(5) manpage for better usages.
  # Update /etc/apt/sources.list repository indexes.
  sudo apt-get update
  # Quietly install apt updates.
  sudo apt-get -q=2 upgrade

  # Bash, and shell utilities
  source bash/make_bash.sh

  # Git
  source git/make_git.sh

  # Vim
  source vim/make_vim.sh

  # TMUX
  source tmux/make_tmux.sh

  # Embedded development environments
  source embedded/make_embedded_tools.sh
  source embedded/make_avr.sh
  source embedded/make_ti.sh

  # Install or upgrade Node.js and configuration files
  #source node/make_nodejs.sh

  # Install or upgrade Python 3 and pip modules
  #source python/make_python3.sh

  # Install or upgrade databases with configurations and launchctl
  #source db/make_db.sh

  # Install Google chrome
  #source os/make_browsers.sh

  # Setup system defaults
  #source os/make_defaults.sh
}

# Complete the installation and prepare system for usage.
function clean_up() {
  echo "Cleaning repository caches..."
  # Remove packages that are no longer installed from local cache.
  # To see cache size: du -sh /var/cache/apt/archives
  sudo apt-get autoclean
  # Removes packages installed by other packages and are no longer needed.
  sudo apt-get autoremove
  # Remove any configuration files left behind by packages, if they exist.
  dpkg --list |grep "^rc" | cut -d " " -f 3 | xargs -r sudo dpkg --purge

  echo "OS settings complete."
  # Confirm a reboot to complete configurations or restart UI.
  printf "\n"
  read -p "Some changes require a system reboot. Reboot now? (y/n) " -n 1
  printf "\n"
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    # Restart computer
    echo "Rebooting system..."
    sudo shutdown -r now
  else
    echo "Some settings will take effect after restart."
  fi
}

# ==============================================================================
# MAIN
# ==============================================================================

# Check script is run from dotfiles directory
check_directories

# Display brief system profile
echo "Hostname: $(uname -n)"
echo "Operating system: $(uname -o)"
echo "Kernel name: $(uname -s)"
echo "Kernel release: $(uname -r)"
echo "Kernel version: $(uname -v)"
echo "Machine: $(uname -m)"
echo "Processor: $(uname -p)"
echo "Hardware platform: $(uname -i)"

# Get the OS version number, if it's not supported here exit 1
get_os_version

# Confirm before preceeding, then parse arguments.
echo ""
if [ $# -le 0 ]; then
  read -p "This may overwrite existing configuration files, are you sure? (y/n) " -n 1
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    install
    clean_up
  else
    show_usage
    echo "Exited without writing files. See the usage and options above for help."
  fi
elif [[ $1 =~ "-" ]]; then
  # parse options
  while [[ $1 =~ "-" ]]; do
    case $1 in
      --help )
        show_usage
        ;;
      --force-all )
        install
        clean_up
        ;;
    esac
    shift
  done
else
  show_usage
  echo "Exited without writing files, unrecognized arguments. See the usage and options above for help."
fi

