cryptic
=======

It is not possible to set custom partitions while using Ubuntu installer (called *ubiquity*) to set up [LVM][1] on top of an [encrypted disk][2]. However, one cannot have two separate partitions for `/` (the system) and for `/home` (user files), which is a fairly common partition scheme.

This script solves this problem by setting up these two partitions once Ubuntu is installed. `/` gets a 20GiB partition, and `/home` gets the remaining space of the disk.

## Compatibility

This script has been tested on Ubuntu 13.10.

LVM and full disk encryption is built-in in the standard installer since Ubuntu 12.10 so I am guessing that *it should work*. I have not tried it though, therefore I cannot guarantee it.

Also, nothing proves that it will work with further releases of Ubuntu, as the script depends on *ubiquity* parameters that might (and will likely) change.

## Usage

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

The script will take some time to run, grab a coffee and be patient.

Once the script has finished, shutdown your computer, remove the USB key you used to install Ubuntu (if any), restart and enjoy your fresh install.

[1]: http://en.wikipedia.org/wiki/Logical_Volume_Manager_(Linux)
[2]: http://en.wikipedia.org/wiki/Disk_encryption
