#!/usr/bin/env bash
#
# This script will only update your dotfiles if your git repo is clean.

# ==============================================================================
# FUNCTION DEFINITIONS
# ==============================================================================

# Check if there are local changes in the repository
require_clean_work_tree () {
    # Update the index
    git update-index -q --ignore-submodules --refresh
    err=0

    # Disallow unstaged changes in the working tree
    if ! git diff-files --quiet --ignore-submodules --
    then
        echo >&2 "Can't run update, you have these UNSTAGED changes."
        git diff-files --name-status -r --ignore-submodules -- >&2
        err=1
    fi

    # Disallow uncommitted changes in the index
    if ! git diff-index --cached --quiet HEAD --ignore-submodules --
    then
        echo >&2 "Can't run update, your index has these UNCOMMITTED changes."
        git diff-index --cached --name-status -r --ignore-submodules HEAD -- >&2
        err=1
    fi

    if [ $err = 1 ]
    then
        echo >&2
    cat <<EOF
  To stash changes use:
    $ git stash

  Then, to reapply those changes:
    $ git stash pop

  To completely remove changes use:
    $ git checkout .

EOF
        exit 1
    fi
}

# ==============================================================================
# MAIN
# ==============================================================================

# Check if there are local changes in the repository
require_clean_work_tree

# If available, pull changes from https://github.com/tobinquadros/dotfiles
git pull origin master

# Print out completion the user
echo "Update complete"
