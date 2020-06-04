#!/bin/bash -e

DBR_VERSION=$1

if [[ "$DBR_VERSION" == "6.5" ]]
then
    
    #https://docs.databricks.com/release-notes/runtime/6.5.html#system-environment

    echo "==> Installing OpenJDK 8u252..."
    # Reference tools to help you manage your development environments 
    source "$HOME/.sdkman/bin/sdkman-init.sh"
    # Installing the same version 2x will result in exit code 1
    # When re-provisioning need to start by removing installed version
    sdk uninstall java 8.0.252-open > /dev/null 2>&1
    sdk install java 8.0.252-open > /dev/null 2>&1

    echo "==> Creating Python 3.7.3 conda environment..."
    source "$HOME/.miniconda/etc/profile.d/conda.sh"
    conda create --yes --name databricks python=3.7.3

    echo "==> Installing R 3.6.3..."
    curl -O http://de.archive.ubuntu.com/ubuntu/pool/main/r/readline/libreadline7_7.0-3_amd64.deb
    curl -O https://cdn.rstudio.com/r/ubuntu-1804/pkgs/r-3.6.3_1_amd64.deb
    sudo apt install -y ./libreadline7_7.0-3_amd64.deb
    sudo apt install -y ./r-3.6.3_1_amd64.deb
    rm -f libreadline7_7.0-3_amd64.deb
    rm -f r-3.6.3_1_amd64.deb
    
else 
    echo "The specified DBR version is not currently supported by this provisioning script"
    exit 1
fi





