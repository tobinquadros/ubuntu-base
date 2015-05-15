#!/usr/bin/env sh
# Creates an Ubuntu USB drive installer from OS X.

# Convert file
ls -la
echo "Source: " && read SOURCE
echo "Target: " && read TARGET

# Choose a drive to put the installer on.
echo -n "Which disk would you like to put the installer on? (eg. disk2): " && read DISK
if [[ $DISK =~ disk[0-9] ]]; then
  # Confirm disk selection before overwriting
  read -p "Erase /dev/$DISK and all it's content to create installer? (y/n) " -n 1; echo ""
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    # Prepare device to accept installer
    diskutil partitionDisk /dev/$DISK GPT free Ubuntu R 
    diskutil unmountDisk /dev/$DISK
    # Copy installer to USB disk
    echo "Ready to copy(dd) $TARGET to /dev/$DISK."
    sudo dd if=$TARGET of=/dev/r${DISK} bs=1m
    # Print success if dd finished with no error
    [[ $? -eq 0 ]] && echo "Install complete, reboot your Mac while holding down option."
  else
    # User did not reply with a 'Y' or 'y' confirmation
    echo "Ok, exiting without creating installer."
    exit
  fi
else
  # User disk selection didn't pass regex validation
  echo "You didn't select a proper disk. Exiting..."
  exit
fi

