#!/usr/bin/env bash
# install.sh

# ==============================================================================
# FUNCTION DEFINITIONS
# ==============================================================================

# Parse options and arguments, then run program.
# TODO: Separate install options.
function parse_options() {
  # Reset all variables that might be set
  unset FORCE_ALL
  unset SOURCES_UPDATE
  unset UPGRADE_ALL
  # If there are more than zero argruments, parse them. (Beware of order here)
  while :
  do
    case $1 in
      --help)
        show_usage
        exit 0
        ;;
      --force-all)
        FORCE_ALL=TRUE
        shift
        ;;
      --sources-update)
        SOURCES_UPDATE=TRUE
        shift
        ;;
      --upgrade-all)
        UPGRADE_ALL=TRUE
        shift
        ;;
      --) # End of options.
        shift
        break
        ;;
      -*) # Invalid option.
        printf >&2 'WARNING: Unknown option (ignored): %s\n' "$1"
        shift
        ;;
      *) # No more options, stop while loop.
        break
        ;;
    esac
  done
}

# Show usage info.
function show_usage() {
  cat <<EOF

Usage: $0 [options] [file ...]

Options:
  --force-all         Run everything with DEFAULT settings, no confirmation.
  --sources-update    Update the sources.list repositories.
                        DEFAULT DOES NOT run "sudo apt-get update"
  --upgrade-all       Upgrade ALL available updates from sources list.
                        DEFAULT DOES NOT run "sudo apt-get upgrade"
  --help              Show this help menu.

EOF
}

# Check script is run from dotfiles directory
function check_directories() {
  if [[ ! "$PWD/install.sh" -ef "$0" ]]; then
    echo ""
    echo "Please run './install.sh' from $HOME/dotfiles/ folder."
    echo ""
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
    echo "You're running Ubuntu 14.04 LTS, that's supported by this installer."
  else
    echo "Your operating system may not be supported, please see the README.md file in this directory."
    exit 1
  fi
}

# Run repository updates if --skip-updates is unset.
function update() {
  echo "update() function called."
  # Fetch updates for /etc/apt/sources.list package indexes.
  if [[ $SOURCES_UPDATE ]]; then
    echo "--sources-update started..."
    sudo apt-get -q=2 update
  fi
  unset $SOURCES_UPDATE
}

# Perform installs by sourcing specific scripts, comment out the source call to disable an installation.
function install() {
  echo "install() function called."
  # Confirm expectation of the install process before proceeding.
  read -p "This installation may overwrite existing configuration files, are you sure? (y/n) " -n 1
  echo ""
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "install started..."

    # Bash, and core utilities.
    # source bash/make_bash.sh

    # Git
    # source git/make_git.sh

    # Vim
    # source vim/make_vim.sh

    # TMUX
    # source tmux/make_tmux.sh

    # Embedded development environments
    # source embedded/make_embedded_tools.sh
    # source embedded/make_avr.sh
    # source embedded/make_ti.sh

    # Node.js
    # source node/make_nodejs.sh

    # Databases
    # source db/make_db.sh

    # System and GUI setup.
    # source os/make_defaults.sh
    # source os/make_apparmor.sh
    # source os/make_error_report.sh

  else
    show_usage
    echo "Exited without writing files. See the usage and options above for help."
    exit 0
  fi
}

# Upgrade packages.
function upgrade() {
  echo "upgrade() function called."
  if [[ $UPGRADE_ALL ]]; then
  # Upgrade all system-wide available updates if --upgrade-all option was passed.
    echo "--upgrade-all started..."
    sudo apt-get -q=2 upgrade
  fi
  echo $UPGRADE_ALL
  unset $UPGRADE_ALL
  echo $UPGRADE_ALL
}

# Complete the installation and prepare system for usage.
function clean_up() {
  echo "clean_up() function called"
  # Check cache size.
  du -sh /var/cache/apt/archives
  # Remove packages that are no longer installed from local cache.
  sudo apt-get autoclean
  # Removes packages installed by other packages and are no longer needed.
  sudo apt-get autoremove
  # Remove any configuration files left behind by packages, if they exist.
  dpkg --list |grep "^rc" | cut -d " " -f 3 | xargs -r sudo dpkg --purge
  # Check that no dependencies are broken.
  sudo apt-get check
}

# Confirm if the user wants to reboot now or wait.
function confirm_reboot() {
  echo ""
  echo "OS setup complete."
  echo ""
  # Confirm a reboot to complete configurations or restart UI.
  read -p "Some changes require a system reboot. Reboot now? (y/n) " -n 1
  echo ""
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    # Restart computer
    sudo shutdown -r +1 "Install and clean up complete, system will reboot now."
  else
    echo ""
    echo "Some settings will take effect after restart. Enjoy your new setup!"
    echo ""
  fi
}

# ==============================================================================
# MAIN
# ==============================================================================

# Check script is run from dotfiles directory.
check_directories

# Display brief system profile to user, just to be friendly.
echo "Hostname: $(uname -n)"
echo "Operating system: $(uname -o)"
echo "Kernel name: $(uname -s)"
echo "Kernel release: $(uname -r)"
echo "Kernel version: $(uname -v)"
echo "Machine: $(uname -m)"
echo "Processor: $(uname -p)"
echo "Hardware platform: $(uname -i)"

# Get the operating system, check if it's supported.
get_os_version

# Get the command line options that were passed.
parse_options

# Get selected updates.
update

# Run the install function.
install

# Upgrade the selected updates.
upgrade

# Clean up caches and old config files left around, manage the packagelist.
clean_up

# Ask if the user would like to reboot or continue working.
confirm_reboot

