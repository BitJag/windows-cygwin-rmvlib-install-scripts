#!/bin/bash

#INSTRUCTIONS

#install cygwin 32-bit.

#During installation, add the following additional packages on top of the default packages that will be installed (latest versions):
    
    # wget, make, gcc-core, git, libmpfr4, libmpc3, doxygen

#Clone the git repository for install script with the following command

    # git clone https://github.com/lachoneus/windows-cygwin-rmvlib-install-scripts.git

#Navigate into the folder downloaded by git and run the following commands:

    # cd windows-cygwin-rmvlib-install-scripts
    # sh ./rmvlib_install.sh

#restart cygwin before testing so that the JAGPATH environment variable, installed by the script earlier, takes effect.

#Test your tool-chain by attempting to build the generic example program located at ~/Jaguar/example_programs/generic_example/.  Run 'make' inside of this folder to test.

#Script

#setup our folders for our tools and build environment path
INSTALLDIRECTORYNAME='Jaguar'
INSTALLPATH="/home/$USER/$INSTALLDIRECTORYNAME"

i=0; n=0; progs=(wget make gcc git doxygen);
for p in "${progs[@]}"; do
    if hash "$p" &>/dev/null
    then
        echo "$p is installed"
        sleep 0.5
        let c++
    else
        echo "$p is not installed"
        sleep 0.5
        let n++
    fi
done

if [ "$n" -gt "0" ]
then
    echo "One or more necessary applications has not been install through the Cygwin setup executable. (Read messages above to see which applications aren't installed)."
    echo "Run Cygwin setup again, and make sure the follow packages are installed:"
    echo " "
    echo "wget, make, gcc-core, git, libmpfr4, libmpc3, doxygen"
    exit

else

#download and install m-64k-atari-mint cross compiler tools
echo  " Downloading and Installing Cross Compiler "
wget --no-check-certificate https://tho-otto.de/download/mint/m68k-atari-mint-base-20200501-cygwin32.tar.xz
tar -xvf ./m68k-atari-mint-base-20200501-cygwin32.tar.xz -C /
rm -rvf ./m68k-atari-mint-base-20200501-cygwin32.tar.xz

#setup our folders for our tools and build environment path
echo  " Adding Tools Directory "

mkdir -vp $INSTALLPATH
mkdir -vp $INSTALLPATH/bin
mkdir -vp $INSTALLPATH/example_programs
mkdir -vp $INSTALLPATH/lib
mkdir -vp $INSTALLPATH/lib/lib
mkdir -vp $INSTALLPATH/lib/include
mkdir -vp $INSTALLPATH/src

echo  " Copy Temporary Assets Directory "
cp -vr ./assets $INSTALLPATH
cd $INSTALLPATH/

echo  " Setting Environment Variable JAGPATH "
export JAGPATH=$INSTALLPATH #export for the session the script is running so libraries install correctly

echo "export JAGPATH=/home/$USER/Jaguar" | tee -a $HOME/.bashrc #make environment variable persistent across sessions.

echo  " Downloading RMAC/RLN Source From GIT Repositories "
cd $INSTALLPATH/src
git clone http://shamusworld.gotdns.org/git/rmac
git clone http://shamusworld.gotdns.org/git/rln
echo  " Downloading jlibc/rmvlib Libraries From GIT Repositories "
git clone https://github.com/sbriais/jlibc.git
git clone https://github.com/sbriais/rmvlib.git

echo "  Begin Building sources  "

#modify and build rmac 2.0.0
echo  " Building RMAC "
cd rmac
make
cp -vr rmac $INSTALLPATH/bin/mac #renaming to make more compatible with sebs makefiles
cd $INSTALLPATH/src

#patching and building rln
echo  " Building RLN "
cd rln
make
cp -vr rln $INSTALLPATH/bin/aln #renaming to make more compatible with sebs makefiles
cd $INSTALLPATH/src

#modify and build jlibc
echo  " Building JLIBC "
cd jlibc
make
make install
cd $INSTALLPATH/src

#modify and build rmvlib
echo  " Building RMVLIB "
cd rmvlib
make
make install
cd $INSTALLPATH/src

#copy libgcc.a from m68k-mint-atari tools
echo  " copy libgcc.a from m68k-mint-atari tools into lib folder "
cd $INSTALLPATH/lib/lib
find /usr/lib/gcc/m68k-atari-mint/ -type f -name "libgcc.a" -exec cp {} ./ \;
cd $INSTALLPATH

echo  " copy example program "
mv -v ./assets/generic_example ./example_programs/
rm -rv ./assets

echo  " DONE! "

echo  " RESTART CYGWIN BEFORE BUILDING EXAMPLE PROGRAM! "

fi
