#!/bin/bash -e

# Read arguments passed to the script
R_VERSION=$1

echo "==> Installing R..."
if [[ $(dpkg-query -W -f='${Status}' r-${R_VERSION} 2>/dev/null | grep -c "ok installed") == "0" ]]
then
    curl -sO https://cdn.rstudio.com/r/ubuntu-2004/pkgs/r-${R_VERSION}_1_amd64.deb
    sudo apt install -y ./r-${R_VERSION}_1_amd64.deb
    rm -f r-${R_VERSION}_1_amd64.deb
    mkdir -p $HOME/R/x86_64-pc-linux-gnu-library/${R_VERSION:0:3}
else
    echo "r-${R_VERSION} already installed, nothing to do." 
fi
