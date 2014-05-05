#!/usr/bin/env bash
# Install or upgrade Python 3 environment

# Install or upgrade Python 3 from homebrew
brew install python3
# Fortran compiler and freetype font library currently required for matplotlib
brew install gfortran
brew install freetype

# Install or upgrade setuptools then pip(3)
pip3 install --upgrade setuptools
pip3 install --upgrade pip
pip3 list --outdated

# Install or upgrade SciPy modules
pip3 install --upgrade numpy
pip3 install --upgrade scipy
pip3 install --upgrade matplotlib
pip3 install --upgrade pandas
pip3 install --upgrade sympy

# These are seperately installed for ipython when using pip3, they have binary
# eggs and are compiled from source. Ensure they succeed!!!
#   pyzmq, needed for IPython’s parallel computing features, qt console and notebook
#   readline (on OS X) or pyreadline (on Windows), needed for the terminal
pip3 install --upgrade pyzmq
pip3 install --upgrade readline

# Install all ipython and main optional dependencies:
#   jinja2, needed for the notebook
#   sphinx, needed for nbconvert
#   pygments, used by nbconvert and the Qt console for syntax highlighting
#   tornado, needed by the web-based notebook
#   nose, used by the test suite
pip3 install --upgrade ipython[all]

# Check for XQuartz (Octave dependency, not available on homebrew)
if [[ -z $(find /Applications/Utilities/ -name "XQuartz.app") ]]; then
  # Install XQuartz
  echo "Installing /Applications/Utilities/XQuartz.app"
  curl http://xquartz-dl.macosforge.org/SL/XQuartz-2.7.5.dmg --output backups/XQuartz-2.7.5.dmg
  hdiutil attach backups/XQuartz-2.7.5.dmg
  sudo installer -package /Volumes/XQuartz-2.7.5/XQuartz.pkg -target LocalSystem
  hdiutil detach /Volumes/XQuartz-2.7.5
else
  echo "/Applications/Utilities/XQuartz.app is already installed."
fi

# Install Octave for ipython %octavemagic, and matlab functions *Requires JRE
brew install octave
pip3 install --upgrade oct2py

# Link ipython directory to ~/.ipython
ln -sFh $HOME/dotfiles/python/ipython/ $HOME/.ipython
