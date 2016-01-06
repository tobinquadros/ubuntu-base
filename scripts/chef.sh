install_chef_client() {
  echo "install_chef_client() function called"
  if [ "$INSTALL_CHEF_CLIENT" = "true" ]; then
    echo "Installing Chef client..."
    wget -O - https://opscode.com/chef/install.sh | sudo bash
  else
    echo "Skipping Chef client install."
  fi
}

# Install Chef client
install_chef_client
