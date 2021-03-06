#!/bin/sh
# RHUM Node Installer
# WARNING: This software makes significant changes to the system behavior
# DISCLAIMER: This software is distributed with no warranty.

#
cp -r libraries/* /usr/share/arduino/libraries
cp conf/mcgill.cfg /etc/network/interfaces.d/
cp conf/mcgill.conf /etc/wpa_supplicant/

# APT Packages
read -p "Update APT dependencies? [y/n] " ans
if [ $ans = y -o $ans = Y -o $ans = yes -o $ans = Yes -o $ans = YES ]
    then
        echo "Installing dependencies via mirror ..."
        cp conf/sources.list /etc/apt/ # includes NON-FREE repo
        apt-get update
        apt-get upgrade -y -qq
        apt-get install firmware-realtek firmware-iwlwifi -y -qq
        apt-get install wireless-tools -y -qq
        apt-get install unzip -y -qq
        apt-get install build-essential -y -qq
        apt-get install python-dev -y -qq
        apt-get install cmake -y -qq
        apt-get install python-serial -y -qq
        apt-get install python-pip -y -qq
        apt-get install python-matplotlib -y -qq
        apt-get install libgtk2.0-dev -y -qq
        apt-get install python-numpy -y -qq
        apt-get install arduino arduino-mk -qq
        apt-get install x11-xserver-utils -y -qq
        apt-get install cython -y  -qq
        apt-get install python-flask -y -qq
        apt-get install python-cherrypy3 -y -qq
        apt-get install python-requests -y -qq
        apt-get install python-setuptools -y -qq
        apt-get install mongodb -y -qq
        apt-get install dnsmasq -y -qq
        apt-get install hostapd -y -qq
        cp conf/ap.cfg /etc/network/interfaces.d/ap.cfg
        cp conf/wired.cfg /etc/network/interfaces.d/wired.cfg
        cp conf/hostapd.conf /etc/hostapd/
        cp conf/dnsmasq.conf /etc/
        cp conf/dhclient.conf /etc/dhcp/
fi
if [ $ans = n -o $ans = N -o $ans = no -o $ans = No -o $ans = NO ]
    then
        echo "Aborting..."
fi

# Pip Packages
read -p "Update Pip modules? [y/n] " ans
if [ $ans = y -o $ans = Y -o $ans = yes -o $ans = Yes -o $ans = YES ]
    then
        echo "Installing Python modules..."
        pip install -r requirements.txt
fi
if [ $ans = n -o $ans = N -o $ans = no -o $ans = No -o $ans = NO ]
    then
        echo "Aborting..."
fi

# Done Message
read -p "Installation Complete! Reboot now? [y/n] " ans
if [ $ans = y -o $ans = Y -o $ans = yes -o $ans = Yes -o $ans = YES ]
    then
    echo "Rebooting..."
    reboot
fi
if [ $ans = n -o $ans = N -o $ans = no -o $ans = No -o $ans = NO ]
    then
        echo "Aborting..."
fi

