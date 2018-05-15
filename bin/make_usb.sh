#!/usr/bin/env sh
# Creates an Ubuntu USB drive installer from OS X.

SOURCE_ISO=$1

if [[ "$#" -ne 1 ]]; then
  echo "USAGE: $0 <source-iso>"
  exit 1
fi

if [[ ! -r $SOURCE_ISO ]]; then
  echo "ERROR: filename not readable"
  exit 1
fi

# Choose a drive to put the installer on.
diskutil list
echo "Which disk would you like to put the installer on? (eg. disk2): " && read DISK

if [[ $DISK =~ disk[0-9] ]]; then

  # Confirm disk selection before overwriting
  read -p "Erase /dev/$DISK and all it's content to create installer? (y/n) " -n 1; echo ""

  if [[ $REPLY =~ ^[Yy]$ ]]; then

    # Prepare device to accept installer
    diskutil partitionDisk /dev/$DISK GPT ExFat Ubuntu R
    diskutil unmountDisk /dev/$DISK

    # Copy installer to USB disk
    echo "Ready to copy (dd) $SOURCE_ISO to /dev/$DISK."
    sudo dd if=$SOURCE_ISO of=/dev/r${DISK} bs=1m

    # Print success if dd finished with no error
    [[ $? -eq 0 ]] && echo "Write completed successfully."

  else

    # User did not reply with a 'Y' or 'y' confirmation
    echo "Ok, exiting without creating installer."
    exit

  fi

else

  # User disk selection didn't pass regex validation
  echo "ERROR: You didn't select a proper disk. Exiting..."
  exit 1

fi

