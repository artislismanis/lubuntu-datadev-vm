#!/bin/bash -e

# Installs tools to help you manage your development environments more effectively

echo "==> Installing Miniconda..."
# Download and install the latest version of Miniconda
# https://docs.conda.io/en/latest/miniconda.html
wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh
bash ~/miniconda.sh -b -f -p $HOME/.miniconda
# Initialise & configure conda
source "$HOME/.miniconda/etc/profile.d/conda.sh"
conda init
conda config --set auto_activate_base false

echo "==> Installing SDKMan!..."
# Download and install SDKMan!
curl -s "https://get.sdkman.io" | bash
source "$HOME/.sdkman/bin/sdkman-init.sh"
sdk selfupdate force
