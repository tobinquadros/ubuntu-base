# Storage Devices

Find logical name for devices available to be partitioned:
```bash
sudo lshw -C disk
```

## Standard Partitioning

#### Partition the drive with GUID partition type (GPT)

Interactively partition with parted, _see `help` for more info_:
```bash
sudo parted /dev/sdb
```

Create new partition table:
```bash
(parted) mktable gpt
```

Create a new partition on the device:
```bash
(parted) mkpart primary 1MiB 100%
```
###### OR:

Non-interactive from the command line:
```bash
sudo parted -s -a optimal /dev/sdb mktable gpt mkpart primary 0% 100%
```

#### Partition the device with a master boot record (MBR, msdos)

Interactively partition with fdisk:
```bash
sudo fdisk /dev/sdb
```

+ Press `n` + `<ENTER>` to add new partition.
+ Input partition settings when prompted.
+ Press `t` + `<ENTER>` to select new partition type.
+ Press `w` + `<ENTER>` to write the partition table to disk.
+ You MUST write changes to disk, otherwise they are not commited

See the `sfdisk` man page for non-interactive MBR partitioning

## RAID Arrays

Use `man mdadm` liberally, there may be more info here later. See [Standard Partitioning](#standard-partitioning) to setup a partition scheme.

By default the multiple devices 'md' driver is not installed:
```bash
sudo apt-get install -y mdadm
```

Setup RAID 1 (mirrored) array with two partitions at /dev/md0:
```bash
sudo mdadm --create /dev/md0 --level=1 --raid-devices=2 /dev/sdb1 /dev/sdc1
```

Check status:
```bash
watch cat /proc/mdstat
# or
sudo mdadm -D <DEVICE>
```

+ Ensure `/etc/mdadm/mdadm.conf` has array definitions.
+ Ensure Grub gets installed on all physical boot devices.
+ [Degraded RAID](https://help.ubuntu.com/14.04/serverguide/advanced-installation.html#raid-degraded) is important for remote systems.


## Logical Volume Manager (LVM)

The overall lvm process is generally:

1. Initialize physical volumes. `pvcreate`
2. Add physical volumes to volume group. `vgcreate`
3. Create logical volumes on the volume group. `lvcreate`


By default the lvm2 package is not installed:
```bash
sudo apt-get install -y lvm2  # executable is `lvm`
```

Use `man lvm` or `man 'lvm subcommand'` liberally.

## Filesystems

View the filesystems currently available with the running kernel:
```bash
cat /proc/filesystems
```

#### Format a filesystem

Create a supported filesystem with the `mkfs` front-end:
```bash
sudo mkfs -t ext4 /dev/sdb1
```

###### OR:

Use a specific filesystem builder, ext* fs defaults are stored in `/etc/mke2fs.conf`:
```bash
# -b = blocksize
sudo mkfs.ext4 -L LABEL -b 1024 /dev/sdb1
```

#### Tune filesystem

Adjust options on ext* fs, see `man tune2fs` for more info:
```bash
# -m = reserve space percentage, default %5
sudo tune2fs -m 0 /dev/sdb1
```

## Mount Device

#### Manually mount

Create mountpoint and mount device for one time use:
```bash
sudo mkdir /mnt/newfs
sudo mount /dev/sdb1 /mnt/newfs
```

#### Automatic mount at boot time

Edit the filesystem table file `/etc/fstab`:
```bash
sudo vim /etc/fstab
```

Add partition/fs in top-to-bottom sequential mount order:
```bash
# /etc/fstab
# DEVICE, MOUNTPOINT, FSTYPE, OPTIONS, DUMP, FSCK
UUID=uuid-goes-here /mnt/newfs ext4 defaults 0 2
```

Re-mount all, or reboot system:
```bash
sudo mount -a
```

#### Set permissions

For one user or group:
```bash
sudo chown -R user:group /mnt/newfs
```

For multiple users with a specific group:
```bash
sudo chgrp plugdev /mnt/newfs
sudo chmod g+w /mnt/newfs
sudo chmod +t /mnt/newfs  # sticky bit
```
