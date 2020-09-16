#!/bin/bash -e

# Installs tools to help you manage your development environments more effectively
# Covering Python, JVM languages, Node.js and Ruby

echo "==> Installing Miniconda..."
if [[  -d "$HOME/.miniconda" ]]
then
    echo "Miniconda already installed, checking for updates."
    source "$HOME/.miniconda/etc/profile.d/conda.sh"
    conda update -n base -c defaults conda > /dev/null 2>&1
else 
    # Download and install the latest version of Miniconda for managing Python environments / packages
    # https://docs.conda.io/en/latest/miniconda.html
    wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh
    bash ~/miniconda.sh -b -f -p $HOME/.miniconda > /dev/null 2>&1
    # Initialise & configure conda
    source "$HOME/.miniconda/etc/profile.d/conda.sh"
    conda init > /dev/null 2>&1
    conda update -n base -c defaults conda > /dev/null 2>&1
    conda config --set auto_activate_base false 
    rm -f miniconda.sh
fi

echo "==> Installing SDKMan!..."
if [[  -d "$HOME/.sdkman" ]]
then
    echo "SDKMan! already installed, checking for updates."
    source "$HOME/.sdkman/bin/sdkman-init.sh"
    sdk selfupdate force > /dev/null 2>&1
else 
    # Download and install SDKMan! for managing JVM languages / tools
    curl -s "https://get.sdkman.io" | bash > /dev/null 2>&1
    source "$HOME/.sdkman/bin/sdkman-init.sh"
    sdk selfupdate force > /dev/null 2>&1
fi

echo "==> Installing NVM..."
if [[  -d "$HOME/.nvm" ]]
then
    echo "NVM already installed, checking for updates."
    cd "$HOME/.nvm"
    TAG=$(git describe --tags `git rev-list --tags --max-count=1`)
    git checkout "$TAG"
else
    # Download and install NVM for managing Node.js installs
    curl -so- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash > /dev/null 2>&1
fi

echo "==> Installing RVM..."
if [[  -d "$HOME/.rvm" ]]
then
    echo "RVM already installed, checking for updates."
    source "$HOME/.rvm/scripts/rvm"
    rvm get stable > /dev/null 2>&1
else
    # Download and install RVM for managing Ruby installs
    curl -sSL https://rvm.io/mpapis.asc | gpg --import - > /dev/null 2>&1
    curl -sSL https://rvm.io/pkuczynski.asc | gpg --import - > /dev/null 2>&1
    curl -sSL https://get.rvm.io | bash -s stable > /dev/null 2>&1
fi