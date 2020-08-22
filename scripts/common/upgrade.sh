#!/bin/bash -eu

echo "==> Update package listing, install available upgrades.."
export DEBIAN_FRONTEND=noninteractive
apt-get -y update
apt-get -y upgrade
apt-get -y dist-upgrade
apt-get -y autoremove