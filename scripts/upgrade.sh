#!/bin/bash -eu

echo "==> Update package listing, install available upgrades.."
apt-get -y update
apt-get -y upgrade
apt-get -y dist-upgrade
apt-get -y autoremove

echo "==> Upgrade Python 3 pip installer.."
pip3 install --upgrade pip --quiet