#!/bin/bash -eu

echo "==> Update package listing, install available upgrades.."
apt-get -y update
apt-get -y upgrade
apt-get -y autoremove