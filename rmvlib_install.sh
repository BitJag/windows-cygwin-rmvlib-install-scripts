#!/bin/bash
 
RED='\033[0;31m'
NC='\033[0m' # No Color


# 1- install cygwin 32-bit.  During installation, add the following additional packages on top of the default packages that will be installed (latest versions):
    
    # make, gcc-core, git, libmpfr4, libmpc3

# 2 - after downloading and installing cygwin, download and install the m68k-atari-mint cross compiler tools executable script by Vincent Riviere from the following link  (name should look something like 'cross-mint-cygwin-20180704-setup.exe.'):

    # http://vincent.riviere.free.fr/soft/m68k-atari-mint/
 
# 3 - Download this script and it's assets and run from your home folder inside a 32-bit cygwin install, only after you have done the previous steps.  Using the following command:

    # sh ./rmvlib_install.sh

# 4 - Test your tool-chain by attempting to build the generic example program located at ~/Jaguar/example_programs/generic_example/.  Run 'make' inside of this folder to test.



#Script

#setup our folders for our tools and build environment path
echo  "\n${RED}Adding Tools Directory${NC}\n"

mkdir -v $HOME/Jaguar
mkdir -v $HOME/Jaguar/example_programs
mkdir -v $HOME/Jaguar/lib
mkdir -v $HOME/Jaguar/lib/lib
mkdir -v $HOME/Jaguar/lib/include
mkdir -v $HOME/Jaguar/src


echo  "\n${RED}Copy Temporary Assets Directory${NC}\n"

cp -vr ./assets $HOME/Jaguar

cd $HOME/Jaguar/

echo  "\n${RED}Setting Environment Variable JAGPATH${NC}\n"

export JAGPATH=/home/$USER/Jaguar #export for the session the script is running so libraries install correctly

echo "export JAGPATH=/home/$USER/Jaguar" | tee -a $HOME/.bashrc #make environment variable persistent across settions.

echo  "\n${RED}Downloading RMAC/RLN Source From GIT Repositories${NC}\n"

cd $HOME/Jaguar/src

git clone http://shamusworld.gotdns.org/git/rmac
git clone http://shamusworld.gotdns.org/git/rln

echo  "\n${RED}Downloading jlibc/rmvlib Libraries From GIT Repositories${NC}\n"

git clone https://github.com/sbriais/jlibc.git
git clone https://github.com/sbriais/rmvlib.git

#modify and build rmac
echo  "\n${RED}Building RMAC${NC}\n"

cd rmac

sed -i '/_attr = cursect | D/c\*a_attr = DEFINED;' expr.c #manual alteration to rmac to make it properly compile display.s, sound.s and paula.s in rmvlib.

make

cd $HOME/Jaguar/src

#patching and building rln
echo  "\n${RED}Building RLN${NC}\n"
cd rln
make
cd $HOME/Jaguar/src

#modify and build jlibc
echo  "\n${RED}Building JLIBC${NC}\n"

cd jlibc

sed -i '/MADMAC=/c\MADMAC=$(JAGPATH)/src/rmac/rmac' Makefile.config #change makefile.config to point to our new rmac
sed -i '/OSUBDIRS=/c\OSUBDIRS=ctype' Makefile #don't build documentation
make
make install

cd $HOME/Jaguar/src

#modify and build rmvlib
echo  "\n${RED}Building RMVLIB${NC}\n"

cd rmvlib

    #fix display.s
cd display
sed -i 's/10-\*/10-pc1/g' display.s
sed -i '/-pc1/i\\tpc1=\*' display.s

sed -i 's/40-\*/40-pc2/g' display.s
sed -i '/-pc2/i\\tpc2=\*' display.s
cd ..

    #fix sound.s
cd sound
sed -i 's/-\*/-pc1/g' sound.s 
sed -i '/-pc1/i\\tpc1=\*' sound.s
    #fix paula.s
sed -i 's/-\*/-pc1/g' paula.s 
sed -i '/padding_/i\\tpc1=\*' paula.s
cd ..

    #change makefiles
sed -i '/MADMAC=/c\MADMAC=$(JAGPATH)/src/rmac/rmac' Makefile.config #change makefile.config to point to our new rmac
sed -i '/OSUBDIRS=/c\OSUBDIRS=' Makefile #don't build documentation
make
make install

cd $HOME/Jaguar/src 

#copy libgcc.a from m68k-mint-atari tools
echo  "\n${RED}copy libgcc.a from m68k-mint-atari tools into lib folder${NC}\n"

cd $HOME/Jaguar/lib/lib

cp -v /opt/cross-mint/lib/gcc/m68k-atari-mint/4.6.4/libgcc.a ./

cd $HOME/Jaguar

#copy example program into tool-chain tree
echo  "\n${RED}copy example program into Jaguar folder.${NC}\n"

mv -v ./assets/generic_example ./example_programs/
rm -rv ./assets

echo  "\n${RED}DONE!${NC}\n"

echo  "\n${RED}RESTART CYGWIN BEFORE BUILDING EXAMPLE PROGRAM!${NC}\n"

echo  "\n${RED}RESTART CYGWIN BEFORE BUILDING EXAMPLE PROGRAM!${NC}\n"

echo  "\n${RED}RESTART CYGWIN BEFORE BUILDING EXAMPLE PROGRAM!${NC}\n"

echo  "\n${RED}RESTART CYGWIN BEFORE BUILDING EXAMPLE PROGRAM!${NC}\n"
