# Introduction
These scripts were put together to make building and installing a specific Atari Jaguar development environment more conveinient. They were also created as way of retracing my steps in the future in case I need to build/install a specific tool or application included in these scripts.

There are no guarantees provided when you use this script.  These scripts will probably break and cease to work as packages update or disappear from the Ubuntu repositories over time.  Or build processes and source files for tools/applications change.

The only updates you can expect from me for these scripts are if and when I feel that I need to update them, but feel free to leave an issue in the tracker. I will do my best to help. Or, feel free to alter the script for your own needs.

This script will install the Removers Library, RMAC, RLN, and the necessary cross compiler tools inside a 32-bit CYGWIN environment in Windows.

# RMAC/RLN/JLIBC/RMVLIB Installer Script
(rmvlib_install.sh)

## About
This script will install a working Atari Jaguar development environment, based on JLIBC and the Remover's Library, on a Windows machine with 32-bit CYGWIN and Vincent Rivière's m68k-atari-mint cross-tools already installed.

________________

## Installed Development Tools
The following tools will be built and installed to **<user's home folder>/Jaguar/**.

### RMAC
A modern version of Atari's old Madmac assembler. Created by Reboot.

source: http://shamusworld.gotdns.org/git/rmac

### RLN
A modern version of Atari's old ALN linker. Created by Reboot.

source: http://shamusworld.gotdns.org/git/rln

### JLIBC
The Remover's standard C library.

source: https://github.com/sbriais/jlibc

### RMVLIB
The Remover's C library for C functions specific to Atari Jaguar developement.

source: https://github.com/sbriais/rmvlib

________________

## Requirements
Windows with an internet connection. This script has only been tested on Windows 10 (5/18/2020).  32-bit CYGWIN and Vincent Rivière's m68k-atari-mint cross-tools is required to be installed before running this script in CYGWIN.

________________

## Installing


Install CYGWIN **32-bit**.  

    https://cygwin.com/install.html

During installation, add the following additional packages on top of the default packages that will be installed (latest versions):
    
    make, gcc-core, git, libmpfr4, libmpc3, doxygen

Download and install the m68k-atari-mint cross compiler tools  from the following link near the top of the page (The name of the download should look something like ' m68k-atari-mint-base-20200501-cygwin32.tar.xz'):

    https://tho-otto.de/crossmint.php
    
Copy this downloaded .TAR file to your home folder in cygwin.  This is usually located at C:\cygwin\home\<user name>

Open CYGWIN and extract into the root of cygwin with the following command:

    tar -xvf ./m68k-atari-mint-base-20200501-cygwin32.tar.xz -C /
    
Clone the git repository for install script with the following command

    git clone https://github.com/lachoneus/windows-cygwin-rmvlib-install-scripts.git

Navigate into the folder downloaded by git and run the following commands:

    cd windows-cygwin-rmvlib-install-scripts
    sh ./rmvlib_install.sh
    
Restart CYGWIN before testing so that the JAGPATH environment variable, installed by the script earlier, takes effect.

Testing - In CYGWIN, navigate to the following location in your home folder and run the make command.

    cd ~/Jaguar/example_programs/generic_example
    make
    
If you don't get any errors while compiling and linking the example program, everything should be built/installed correctly for the Jaguar development environment.

## Uninstall
Just delete the folder c:/cygwin and start from the beginning.  ***!!Be sure to backup your source code!!***
________________
________________

# Additional Jaguar Development Binaries Linux Installer

In development.  Currently, if you want to run virtualjaguar, jcp or other useful tools for Jaguar development; you will need to download, build, and install, or find executables of these tools yourself.
