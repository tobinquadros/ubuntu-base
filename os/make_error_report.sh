#!/usr/bin/env bash
# make_error_report.sh

# Disable the whoopsie error reporting daemon.
sudo sh -c "cat << EOF > /etc/default/whoopsie
[General]
report_crashes=false
EOF"
# Stop the daemon. You can also remove it: sudo apt-get purge whoopsie
sudo service whoopsie stop

# Disable apport.
sudo sh -c "cat << EOF > /etc/default/apport
# set this to 0 to disable apport, or to 1 to enable it
# you can temporarily override this with
# sudo service apport start force_start=1
enabled=0
EOF"
# Stop the daemon. You can also remove it: sudo apt-get purge apport
sudo service apport stop

