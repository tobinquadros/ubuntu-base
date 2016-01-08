install_chef_client() {
  echo "install_chef_client() function called"
  if [ "$INSTALL_CHEF_CLIENT" = "true" ]; then
    # We need not use `| sudo bash` when this goes live
    curl -L https://opscode.com/chef/install.sh | sudo bash
  else
    echo "Skipping chef-client install."
  fi
}

# Install Chef client
install_chef_client || echo "install_chef_client() failed"
