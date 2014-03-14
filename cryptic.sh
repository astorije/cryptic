#!/bin/sh

set -e

bold=`tput bold`
normal=`tput sgr0`
green=`tput setaf 2`
yellow=`tput setaf 3`
white=`tput setaf 7`
greenbg=`tput setab 2`

printf "\n"

# Shrink the root logical volume after checking (e2fsck) and shrinking (resize2fs) the root fs
printf "  ${yellow}[>     ]${normal}  1. Resizing root...                   "
sudo lvresize --resizefs --size 20G /dev/ubuntu-vg/root > /dev/null 2>&1
printf "${bold}${green}OK${normal}\n"

# Create a logical volume the size of all remaining space in the volume group
printf "  ${yellow}[>>    ]${normal}  2. Creating a LV for home...          "
sudo lvcreate --extents 100%FREE --name home ubuntu-vg > /dev/null
printf "${bold}${green}OK${normal}\n"

# Create an ext4 filesystem for home (taking the whole space in the logical volume)
printf "  ${yellow}[>>>   ]${normal}  3. Making a filesystem for home...    "
sudo mkfs.ext4 -q /dev/ubuntu-vg/home
printf "${bold}${green}OK${normal}\n"

# Check the 2 filesystems after operations
printf "  ${yellow}[>>>>  ]${normal}  4. Checking that LVs are clean...     "
sudo e2fsck -f /dev/ubuntu-vg/root > /dev/null 2>&1
sudo e2fsck -f /dev/ubuntu-vg/home > /dev/null 2>&1
printf "${bold}${green}OK${normal}\n"

# Retrieve the home content from the original root partition
printf "  ${yellow}[>>>>> ]${normal}  5. Moving home to its new location... "
sudo mkdir -p /mnt/ubuntu-{root,home}
sudo mount /dev/ubuntu-vg/root /mnt/ubuntu-root
sudo mount /dev/ubuntu-vg/home /mnt/ubuntu-home
sudo rsync -aXS /mnt/ubuntu-root/home/. /mnt/ubuntu-home/.
sudo rm -rf /mnt/ubuntu-root/home/*
printf "${bold}${green}OK${normal}\n"

# Update fstab to mount the home volume at startup
printf "  ${yellow}[>>>>>>]${normal}  6. Updating the fstab...              "
echo "/dev/mapper/ubuntu--vg-home  /home  ext4  defaults  0  2" | sudo tee --append /mnt/ubuntu-root/etc/fstab > /dev/null
printf "${bold}${green}OK${normal}\n"

# Success message
printf "Success! You can now turn off your computer.\n"

# Success message
printf "\n  ${greenbg}                                                   ${normal}\n"
printf "  ${white}${greenbg}${bold}        You can now turn off your computer.        ${normal}"
printf "\n  ${greenbg}                                                   ${normal}\n\n"
