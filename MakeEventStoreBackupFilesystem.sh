#!/bin/bash
set -eo pipefail 
set -u

# Create working and backup copies of fstab
cp /etc/fstab ~/
sudo cp /etc/fstab /etc/fstab.original

backupdevice=sdc
backupdisk="/dev/${backupdevice}"
backuppartition=${backupdisk}1

# Set value to be used for filesystem mount point folder
mountpointname='data2'
mountpoint=/media/$mountpointname

# Set value to be used for filesystem label - max length 16 chars
fslabel=$(hostname)-$mountpointname

# Set value for filesystem barriers - 0 if using Premium Storage w/ ReadOnly Caching or NoCache; 1 otherwise
b=0

if [ ! -b "${backuppartition}" ]; then
	(echo n; echo p; echo 1; echo ; echo ; echo p; echo w;) | sudo fdisk ${backupdisk}

	# Format and label filesystem
	# -F is used to force the creation of the filesystem here, which we can do safely since this script should only be executed the first time the VM is built.
	# Doing this on an existing VM with data on it is a dangerous thing to do. USE WITH CARE
	echo Creating ext4 filesystem
	sudo mkfs.ext4 ${backuppartition} -L ${fslabel} -F -F
	echo Checking ext4 filesystem
	sudo fsck ${backuppartition}
	echo ${backuppartition} is now an ext4 file system
else
	echo Disk was already formatted.
fi

# Get value of UUID for new filesystem
uuid=$(sudo blkid -p ${backuppartition} | grep -oP '[-a-z0-9]{36}')
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

# After initial provisioning, use these commands to obtain disk device or UUID of filesystem based on label
#disk=$(blkid -L ${fslabel})
#uuid=$(blkid | grep "LABEL=\"${fslabel}\"" | grep -oP '[-a-z0-9]{36}')

exit 0
