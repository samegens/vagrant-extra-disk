#!/bin/bash
set -eo pipefail 
set -u

# Create working and backup copies of fstab
cp /etc/fstab ~/
sudo cp /etc/fstab /etc/fstab.original

# sda and sdb are taken by the actual VM image and the configdrive so we have to use sdc.
disk=/dev/sdc
partition=${disk}1

# Set value to be used for filesystem mount point folder
mountpoint=/mnt/extradisk

# Set value to be used for filesystem label - max length 16 chars
fslabel=extradisk

if [ ! -b "${partition}" ]; then
	(echo n; echo p; echo 1; echo ; echo ; echo p; echo w;) | sudo fdisk ${disk}

	# Format and label filesystem
	# -F is used to force the creation of the filesystem here, which we can do safely since this script should only be executed the first time the VM is built.
	# Doing this on an existing VM with data on it is a dangerous thing to do. USE WITH CARE
	echo Creating ext4 filesystem
	sudo mkfs.ext4 ${partition} -L ${fslabel} -F
	echo ${partition} is now an ext4 file system
else
	echo Disk was already formatted.
fi

# Get value of UUID for new filesystem
uuid=$(sudo blkid -p ${partition} | grep -oP '[-a-z0-9]{36}')
echo uuid = $uuid

# Create mount point folder
sudo mkdir -p $mountpoint
echo Mount point created

# Add new filesystem to working copy of fstab
echo "UUID=${uuid} ${mountpoint} ext4 defaults,noatime 0 0" >> ~/fstab
echo New filesystem appended to temp fstab 

# Move working copy of fstab to etc folder
sudo mv ~/fstab /etc/fstab
echo Temp fstab moved to /etc/fstab

# Mount all unmounted filesystems
sudo mount -a
echo All unmounted filesystems are now mounted
