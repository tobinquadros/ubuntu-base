# chef-client packages can be found at https://downloads.chef.io/chef-client/ubuntu/
install_chef_client() {
  echo "install_chef_client() function called"
  if [ -n $CHEF_CLIENT_PACKAGE ]; then
    PACKAGE_NAME=$(basename $CHEF_CLIENT_PACKAGE)
    curl -O $CHEF_CLIENT_PACKAGE
    if [ "$(sha1sum $PACKAGE_NAME | awk '{print $1 }')" = "$CHEF_CLIENT_CHECKSUM" ]; then
      sudo dpkg -i $PACKAGE_NAME
    else
      echo "ERROR: $PACKAGE_NAME checksum mismatch"
      exit 1
    fi
  else
    echo "Skipping chef-client install"
  fi
}

##############################################################################
# Main
##############################################################################

install_chef_client || echo "FAILED: install_chef_client()"
