# ==============================================================================
# BASH UTILITY FUNCTION DEFINITIONS
# ==============================================================================

# cd into whatever the forefront Finder window directory is.
function cdf() {
  cd $(osascript -e \
    'tell app "Finder" to POSIX path of (insertion location as alias)')
}

# Quick duplication of files and directories
function dupl() {
  if [ $1 == '-r' ]; then
    rm -i $(ls -a | grep .*~$)
  else
    cp -PRv $1 ${1}~
  fi
}

# Create a new directory and enter it
function md() {
  mkdir -p "$@" && cd "$@"
}

# ==============================================================================
# TMUX HELPERS
# ==============================================================================

# TMUX watch process in slit window
function tmw {
  tmux split-window -dh "$*"
}

