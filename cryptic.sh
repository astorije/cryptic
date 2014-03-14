#!/bin/sh

# Shrink the root logical volume after checking (e2fsck) and shrinking (resize2fs) the root fs
sudo lvresize --resizefs --size 20G /dev/ubuntu-vg/root

# Create a logical volume the size of all remaining space in the volume group
sudo lvcreate --extents 100%FREE --name home ubuntu-vg

# Create an ext4 filesystem for home (taking the whole space in the logical volume)
sudo mkfs.ext4 /dev/ubuntu-vg/home

# Retrieve the home content from the original root partition
sudo mkdir -p /mnt/ubuntu-{root,home}
sudo mount /dev/ubuntu-vg/root /mnt/ubuntu-root
sudo mount /dev/ubuntu-vg/home /mnt/ubuntu-home
sudo rsync -aXS /mnt/ubuntu-root/home/. /mnt/ubuntu-home/.
sudo rm -rf /mnt/ubuntu-root/home/*
