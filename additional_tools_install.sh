#!/bin/bash

#Before running this script, be sure to install the wget, p7zip, unzip packages by running the cygwin setup again and selecting the appropriate packages to install.

TMPDIRECTORY=/tmp
INSTALLDIRECTORYNAME='Jaguar'
INSTALLPATH="/home/$USER/$INSTALLDIRECTORYNAME"


echo " "
echo "Installer script for Virtual Jaguar, Seb's Jaguar Image Converter, ray's lz77 Packer, and the latest version of Tursi's JCP. Script last updated 6/13/2021 "

echo "Installation requires the installation of the following packages through Cygwin's setup. atool, wget, p7zip, unzip, gcc-core, gcc-g++(same version as gcc-core) "

echo "Sources are pulled from the following locations on the web: "

echo "Virtual Jaguar - https://github.com/mirror/virtualjaguar "
echo "Seb's Jaguar Image Converter - http://removers.free.fr/softs/archives/converter-0.1.9.tar.gz "
echo "Ray's lz77 Packer - http://s390174849.online.de/ray.tscc.de/files/lz77_v13.zip "

echo "Consider supporting these developers and their effors with donation and feeback. "

echo " "

echo " "

i=0; n=0; progs=(atool wget 7z unzip gcc g++);
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
    echo "atool, wget, p7zip, unzip, gcc-core, gcc-g++"
    exit

else


echo " "
echo "Making directory structure for building and final binaries. "
echo " "

mkdir -v $TMPDIRECTORY/tmp_additional_jaguar_dev_binaries
cd $TMPDIRECTORY/tmp_additional_jaguar_dev_binaries
mkdir -v ./bin
mkdir -v ./src
mkdir -v ./src/other_binaries

#Download and unpack sources from web, and then remove archived files
echo " "
echo "Download and unpack sources from web, and then move archived source files."
echo " "

#virtualjaguar
#need to download unrar to unpack virtualjaguar properly
wget http://www.rarlab.com/rar/unrarsrc-5.1.7.tar.gz
tar -xzvf unrarsrc-5.1.7.tar.gz
cd unrar
make
cp -v ./unrar.exe /bin/
cd ..
rm -rvf ./unrar ./unrarsrc-5.1.7.tar.gz
wget https://icculus.org/virtualjaguar/tarballs/virtualjaguar-2.1.2-win32.rar
aunpack -X ./virtualjaguar ./virtualjaguar-2.1.2-win32.rar
mv -v ./virtualjaguar-2.1.2-win32.rar ./src/other_binaries
rm -rvf /bin/unrar.exe

#jcp
#cygwin does not have support for kernel level usb communication, so a linux version of jcp is moot.  If you wish to run jcp, you will need to download, install, and run it manually as a windows execuatable, outside of cygwin.

#Our suggestion would be to create a batch file in the same directory as your makefile, run make, and then in a seperate windows command prompt run your batch file for jcp.

#lz77
wget http://s390174849.online.de/ray.tscc.de/files/lz77_v13.zip
unzip lz77_v13.zip
mv -v ./lz77_v13.zip ./src/other_binaries

#jag-image-converter
git clone https://github.com/sbriais/jconverter.git
rm -rvf ./jconverter/*.tar*
rm -rvf ./jconverter/*.zip
rm -rvf ./jconverter/binaries/linux/

#Build Binaries

echo " "
echo "$Begin building binaries. "

#lz77
echo " "
echo "Building lz77. "
echo " "
sleep 1
cd lz77/
gcc lz77.c -o lz77 -O2
cd ..

#jag-image-converter
#currently we can't build this natively in linux so we are using a static binary that is good enough for most uses.

#Hopefully this application will be ported to something more build friendly in the future.


#copy build binaries to bin folder
echo " "
echo "Copy built binaries to bin folder. "
echo " "

cp -v ./virtualjaguar/virtualjaguar/virtualjaguar.exe ./bin/
cp -v ./lz77/lz77.exe ./bin/
cp -v ./jconverter/binaries/windowsXP/converter.exe ./bin/jag-image-converter.exe


#remove build directores
echo " "
echo "Remove build directores. "
echo " "

rm -rvf ./virtualjaguar/
rm -rvf ./lz77/
rm -rvf ./jcp/
rm -rvf ./converter/


#copy binaries and sources to rmac/rln/jlibc/rmvlib toolchain Jaguar directory in the users home directory
echo " "
echo "Copy bin folder with included binaries to toolchain directory $INSTALLPATH "
echo " "

cp -vur ./bin/ $INSTALLPATH/
cp -vur ./src/ $INSTALLPATH/


#copy binaries to the cygwin /bin folder so they can be envoked directly
echo " "
echo "Copy binaries to the cygwin /bin folder so they can be envoked directly $INSTALLPATH "
echo " "

cp -vur $INSTALLPATH/bin/virtualjaguar.exe /bin
cp -vur $INSTALLPATH/bin/lz77.exe /bin
cp -vur $INSTALLPATH/bin/jag-image-converter.exe /bin

#backout and delete temp directory
echo " "
echo "Remove temporary directory. "
echo " "

cd ~
rm -rvf $TMPDIRECTORY/tmp_additional_jaguar_dev_binaries/

echo " "
echo "Finished!   Binaries are located in your home directory at $INSTALLPATH/bin directory.  Also, virtualjaguar, jag-image-converter, and lz77 can all be invoked directly from any where from while in Cygwin."


fi
