#!/bin/sh
#    Simple LibreSwan Upgrade Script
#
#    Copyright (C) 2015 Edwin Ang <edwin@theroyalstudent.com>
#
#    This work is licensed under the Creative Commons Attribution-ShareAlike 3.0
#    Unported License: http://creativecommons.org/licenses/by-sa/3.0/

if [ `id -u` -ne 0 ]
then
  echo "Please start this script with root privileges!"
  echo "Try again with sudo."
  exit 0
fi

ipsec --version | grep 3.13 > /dev/null
if [ "$?" = "0" ]
then
  echo "You already have LibreSwan 3.13 installed!"
  echo "Do you wish to continue anyway?"
  while true; do
    read -p "" yn
    case $yn in
      [Yy]* ) break;;
      [Nn]* ) exit 0;;
      * ) echo "Please answer with Yes or No [y|n].";;
    esac
  done
  echo ""
fi

echo "This script will build and install LibreSwan 3.13 on your server."
echo "This is intended for users who have already installed a VPN server but have LibreSwan of version < 3.13 installed."
echo "Do you wish to continue?"

while true; do
  read -p "" yn
  case $yn in
    [Yy]* ) break;;
    [Nn]* ) exit 0;;
    * ) echo "Please answer with Yes or No [y|n].";;
  esac
done

echo ""

mkdir -p /opt/src
cd /opt/src
echo "Downloading LibreSwan's source..."
wget -qO- https://download.libreswan.org/libreswan-3.13.tar.gz | tar xvz > /dev/null
cd libreswan-3.13
echo "Compiling LibreSwan..."
make programs > /dev/null
echo "Installing LibreSwan..."
make install > /dev/null

ipsec --version | grep 3.13 > /dev/null

if [ "$?" = "0" ]
then
  echo "LibreSwan 3.13 was installed successfully!"
  
  # this script is for users with an existing instlallation, so they most probably will not have the ipsec-assist service installed.

  service xl2tpd restart
  service ipsec restart

  exit 0;;
fi

echo "LibreSwan 3.13 was not installed successfully :/"
echo "Exiting script."

exit 0