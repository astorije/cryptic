cryptic
=======

It is not possible to set custom partitions while using Ubuntu installer (called *ubiquity*) to set up [LVM][1] on top of an [encrypted disk][2]. However, one cannot have two separate partitions for `/` (the system) and for `/home` (user files), which is a fairly common partition scheme.

This script solves this problem by setting up these two partitions once Ubuntu is installed. `/` gets a 20GiB partition, and `/home` gets the remaining space of the disk.

## Compatibility

This script has been tested on Ubuntu 13.10.

LVM and full disk encryption is built-in in the standard installer since Ubuntu 12.10 so I am guessing that *it should work*. I have not tried it though, therefore I cannot guarantee it.

Also, nothing proves that it will work with further releases of Ubuntu, as the script depends on *ubiquity* parameters that might (and will likely) change.

## Basic usage

This script is supposed to be headache-free so its usage is kept simple.

Follow the normal Ubuntu installation process, and when reaching the **Installation type** step:

- Select *Erase disk and install Ubuntu*
- Check *Encrypt the new Ubuntu installation for security*
- Check *Use LVM with the new Ubuntu installation* (which should be checked when checking the previous option anyway)

Go on with the normal installation.

When the **Installation Complete** box pops up, hit the close button (`x`) instead of *Restart Now* to start the live session. The script cannot be run from the installed system, it has to be run from the live session (CD or USB key).

Open a *Terminal* (by hitting the `Super`/`Windows` key of your keyboard and typing *Terminal* in the search field), and type the following lines:

    wget -N git.io/cryptic.sh
    chmod +x cryptic.sh
    ./cryptic.sh

The first line downloads the script, so you need an Internet connection up and running.

If you restarted your computer after the installation, your disk passphrase will be asked at the beginning of the process.
The script will take some time to run, grab a coffee and be patient.

Once the script has finished, shutdown your computer, remove the USB key or CD you used to install Ubuntu, restart and enjoy your fresh install.

## Advanced usage

### How to run `cryptic` without an Internet connection

The `wget` command assumes that you have access to the Internet. If not, download the script on another machine that is connected. Copy the file on a USB key and paste it in the *Home* folder (accessible through the second icon from the *Launcher*, the main menu on the left).

Open a *Terminal* and type the following lines:

    chmod +x cryptic.sh
    ./cryptic.sh

### Setting up a custom size for the system partition

By default, the script creates a system partition of 20G. You can manually set a size as an argument, such as `./cryptic.sh 15G`.

The argument has to be a numeric value followed by a unit. Available units are:

- M for megabytes
- G for gigabytes
- T for terabytes
- P for petabytes
- E for exabytes

However, be very careful when providing a custom size, as:
- it must not be larger than your disk capacity
- it must not be smaller than the size taken by Ubuntu files (or data would be permanently lost)

(Freely adapted from [`lvmresize` documentation][3])

### Checking the changes

Once using the installed system, you can check that the changes have been successfully applied by running the following command line:

    df -h | grep unt

It should display something like this:

    Filesystem                   Size  Used Avail Use% Mounted on
    /dev/mapper/ubuntu--vg-root   20G  3.2G   16G  17% /
    /dev/mapper/ubuntu--vg-home   89G   58M   84G   1% /home

Some information might vary, like the size of the root partition if you have specified a custom size when running the script, or the size of the home partition which depends on your disk capacity.

The important piece of information here is that you have two partitions (`root` and `home`) and that they are both members of the main Volume Group (`ubuntu-vg`).

[1]: http://en.wikipedia.org/wiki/Logical_Volume_Manager_(Linux)
[2]: http://en.wikipedia.org/wiki/Disk_encryption
[3]: http://linux.die.net/man/8/lvresize
