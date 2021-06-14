# Introduction
These scripts were put together to make building and installing a specific Atari Jaguar development environment more conveinient. They were also created as way of retracing my steps in the future in case I need to build/install a specific tool or application included in these scripts.

There are no guarantees provided when you use this script.  These scripts will probably break and cease to work as packages update or links to downloads change or disappear over time.

The only updates you can expect from me for these scripts are if and when I feel that I need to update them, but feel free to leave an issue in the tracker. I will do my best to help. Or, feel free to alter the script for your own needs.

This script will install the Removers Library, RMAC, RLN, and the necessary cross compiler tools inside a 32-bit Cygwin environment in Windows.

# RMAC/RLN/JLIBC/RMVLIB Installer Script
(rmvlib_install.sh)

## About
This script will install a working Atari Jaguar development environment, based on JLIBC and the Remover's Library, on a Windows machine with 32-bit Cygwin and m68k-atari-mint cross-tools already installed.

________________

## Installed Development Tools
The following tools will be built and installed to **c:\cygwin\home\<user's home folder>\Jaguar\**.

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
Windows with an internet connection. This script has only been tested on Windows 10 (6/13/2020).  A 32-bit Cygwin installation is also required.

________________

## Installing


Install Cygwin **32-bit**.  

    https://cygwin.com/install.html

During installation, add the following additional packages on top of the default packages that will be installed (latest versions):
    
    wget, make, gcc-core, git, libmpfr4, libmpc3, doxygen
    
Open Cygwin and clone the git repository for install script with the following command

    git clone https://github.com/lachoneus/windows-cygwin-rmvlib-install-scripts.git

Navigate into the folder downloaded by git and run the following commands:

    cd windows-cygwin-rmvlib-install-scripts
    sh ./rmvlib_install.sh
    
Restart Cygwin before testing so that the JAGPATH environment variable, installed by the script earlier, takes effect.

Testing - In Cygwin, navigate to the following location in your home folder and run the make command.

    cd ~/Jaguar/example_programs/generic_example
    make
    
If you don't get any errors while compiling and linking the example program, everything should be built/installed correctly for the Jaguar development environment.

## Uninstall
Just delete the folder c:/cygwin and start from the beginning.  ***!!Be sure to backup your source code!!***
________________
________________

# Additional Jaguar Development Binaries Linux Installer

The additional_tools_install.sh script installs VirtualJaguar (Atari Jaguar emulator), jag-image-converter (Removers graphics conversion tool. Originally called "converter"), and lz77 (used for packing data for your Jaguar programs).  After install you can run "make vj" which will build your program and automatically run your program with VirtualJaguar.  lz77 and jag-image-converter can be inivoked in any directory to convert and pack graphics and other data.

Before running the additional_tools_install.sh script in Cygwin, we need some additional packages installed. Run the Cygwin Setup executable you used to install Cygwin with, and select and install the following additional packages.

    atool, p7zip, unzip, gcc-g++

NOTE: Make sure that the version you number for gcc-g++ is the same as gcc-core.

Afterwards, open Cygwin and navigate to the the appropriate folder with the script and run it.

    cd windows-cygwin-rmvlib-install-scripts
    sh ./additional_tools_install.sh
