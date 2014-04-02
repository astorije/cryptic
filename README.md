cryptic
=======

It is currently not possible to set custom partitions on a [fully encrypted disk][1] using Ubuntu installer with [LVM][2] enabled.

This script offers a solution by setting up two partitions after installing Ubuntu, using a fairly common partition scheme: `/` (the system) gets a 20GiB partition and `/home` (user files) gets the remaining space of the disk.

## Basic usage

Follow the normal Ubuntu installation process (make sure to enable your Internet connection), and when reaching the **Installation type** step:

- Select *Erase disk and install Ubuntu*
- Check *Encrypt the new Ubuntu installation for security*
- Check *Use LVM with the new Ubuntu installation* if not already checked

Go on with the normal installation.

When the **Installation Complete** box pops up, hit the close button (`x`) instead of *Restart Now* to start the live session.

Open a *Terminal* (by hitting the `Super`/`Windows` key of your keyboard and typing *Terminal* in the search field), and type the following lines:

    wget -N git.io/cryptic.sh
    chmod +x cryptic.sh
    ./cryptic.sh

After a while, a success message shows up. Shutdown your computer, remove the USB key or DVD you used to install Ubuntu, restart and enjoy your fresh install.

## Troubleshooting

### I don't have access to the Internet

The `wget` command assumes that you have access to the Internet. If not, download the script on another machine that is connected. Copy the file on a USB key and paste it in the *Home* folder (accessible through the second icon from the *Launcher*, the main menu on the left). Open a *Terminal* and type the following lines:

    chmod +x cryptic.sh
    ./cryptic.sh

### I get the error "This script must be run from a live session"

The script cannot be run from the installed system. If this message appears, re-insert the USB key or DVD you used to install Ubuntu, restart your computer, select *Try Ubuntu* and follow the steps described in the *Basic usage* section.

Your disk passphrase will be asked at the beginning of the process but for security reasons, you will not see it on screen as you type.

## Advanced usage

### Setting up a custom size for the system partition

By default, the script creates a system partition of 20G. You can manually set a size as an argument, such as `./cryptic.sh 15G`.

The argument has to be a numeric value followed by a unit (freely adapted from [`lvmresize` documentation][3]). Available units are:

- M for megabytes
- G for gigabytes
- T for terabytes
- P for petabytes
- E for exabytes

However, be very careful when providing a custom size, as:
- it must not be larger than your disk capacity
- it must not be smaller than the size taken by Ubuntu files (or data would be permanently lost)

### Checking the changes

Once using the installed system, you can check that the changes have been successfully applied by running the following command line:

    df -h | grep unt

It should display something like this:

    Filesystem                   Size  Used Avail Use% Mounted on
    /dev/mapper/ubuntu--vg-root   20G  3.2G   16G  17% /
    /dev/mapper/ubuntu--vg-home   89G   58M   84G   1% /home

The size of the root partition may vary if you have specified a custom size when running the script, and the size of the home partition will vary as it depends on your disk capacity. The important piece of information here is that you have two partitions (`root` and `home`) and that they are both members of the main Volume Group (`ubuntu-vg`).

## Compatibility

This script has been tested on Ubuntu 13.10.

LVM and full disk encryption were introduced in the standard installer since Ubuntu 12.10 so the script *should* work there too, though without any guarantee. This script might also not work with further releases of Ubuntu. Please create issues if you encounter any incompatibility.

[1]: http://en.wikipedia.org/wiki/Disk_encryption
[2]: http://en.wikipedia.org/wiki/Logical_Volume_Manager_(Linux)
[3]: http://linux.die.net/man/8/lvresize
