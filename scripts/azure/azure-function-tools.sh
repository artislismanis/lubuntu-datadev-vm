#!/bin/bash -e

echo "==> Installing Azure Function Core Tools..."
wget -q https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
rm -f packages-microsoft-prod.deb
apt-get update
apt-get install azure-functions-core-tools-3
