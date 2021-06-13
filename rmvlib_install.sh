#!/bin/bash

#INSTRUCTIONS

#install cygwin 32-bit.

#During installation, add the following additional packages on top of the default packages that will be installed (latest versions):
    
    # make, gcc-core, git, libmpfr4, libmpc3, doxygen

#Download and install the m68k-atari-mint cross compiler tools  from the following link near the top of the page (name should look something like ' m68k-atari-mint-base-20200501-cygwin32.tar.xz'):

    # https://tho-otto.de/crossmint.php

#Copy this downloaded .TAR file to your home folder in cygwin.  This is usually located at C:\cygwin\home\<user name>

#Open cygwin and extract into the root of cygwin with the following command

    # tar -xvf ./m68k-atari-mint-base-20200501-cygwin32.tar.xz -C /

#Clone the git repository for install script with the following command

    # git clone https://github.com/lachoneus/windows-cygwin-rmvlib-install-scripts.git

#Navigate into the folder downloaded by git and run the following commands:

    # cd windows-cygwin-rmvlib-install-scripts
    # sh ./rmvlib_install.sh

#restart cygwin before testing so that the JAGPATH environment variable, installed by the script earlier, takes effect.

#Test your tool-chain by attempting to build the generic example program located at ~/Jaguar/example_programs/generic_example/.  Run 'make' inside of this folder to test.

#Script

#setup our folders for our tools and build environment path
RED='\033[0;31m'
NC='\033[0m' # No Color
INSTALLDIRECTORYNAME='Jaguar'
INSTALLPATH="/home/$USER/$INSTALLDIRECTORYNAME"

#setup our folders for our tools and build environment path
echo  "\n${RED}Adding Tools Directory${NC}\n"

mkdir -vp $INSTALLPATH
mkdir -vp $INSTALLPATH/bin
mkdir -vp $INSTALLPATH/example_programs
mkdir -vp $INSTALLPATH/lib
mkdir -vp $INSTALLPATH/lib/lib
mkdir -vp $INSTALLPATH/lib/include
mkdir -vp $INSTALLPATH/src

echo  "\n${RED}Copy Temporary Assets Directory${NC}\n"
cp -vr ./assets $INSTALLPATH
cd $INSTALLPATH/

echo  "\n${RED}Setting Environment Variable JAGPATH${NC}\n"
export JAGPATH=$INSTALLPATH #export for the session the script is running so libraries install correctly

echo "export JAGPATH=/home/$USER/Jaguar" | tee -a $HOME/.bashrc #make environment variable persistent across sessions.

echo  "\n${RED}Downloading RMAC/RLN Source From GIT Repositories${NC}\n"
cd $INSTALLPATH/src
git clone http://shamusworld.gotdns.org/git/rmac
git clone http://shamusworld.gotdns.org/git/rln
echo  "\n${RED}Downloading jlibc/rmvlib Libraries From GIT Repositories${NC}\n"
git clone https://github.com/sbriais/jlibc.git
git clone https://github.com/sbriais/rmvlib.git

echo "${RED}\n\nBegin Building sources\n\n${NC}"

#modify and build rmac 2.0.0
echo  "\n${RED}Building RMAC${NC}\n"
cd rmac
make
cp -vr rmac $INSTALLPATH/bin/mac #renaming to make more compatible with sebs makefiles
cd $INSTALLPATH/src

#patching and building rln
echo  "\n${RED}Building RLN${NC}\n"
cd rln
make
cp -vr rln $INSTALLPATH/bin/aln #renaming to make more compatible with sebs makefiles
cd $INSTALLPATH/src

#modify and build jlibc
echo  "\n${RED}Building JLIBC${NC}\n"
cd jlibc
make
make install
cd $INSTALLPATH/src

#modify and build rmvlib
echo  "\n${RED}Building RMVLIB${NC}\n"
cd rmvlib
make
make install
cd $INSTALLPATH/src

#copy libgcc.a from m68k-mint-atari tools
echo  "\n${RED}copy libgcc.a from m68k-mint-atari tools into lib folder${NC}\n"
cd $INSTALLPATH/lib/lib
find /usr/lib/gcc/m68k-atari-mint/ -type f -name "libgcc.a" -exec cp {} ./ \;
cd $INSTALLPATH

echo  "\n${RED}copy example program${NC}\n"
mv -v ./assets/generic_example ./example_programs/
rm -rv ./assets

echo  "\n${RED}DONE!${NC}\n"

echo  "\n${RED}RESTART CYGWIN BEFORE BUILDING EXAMPLE PROGRAM!${NC}\n"
