#!/bin/bash -e

# Read arguments passed to the script
DBR_VERSION=$1

if [[ -f "$HOME/.dbr_version" && $(cat $HOME/.dbr_version) !=  $DBR_VERSION ]]
then
    EXISTING_DBR_VERSION=$(cat $HOME/.dbr_version)
    echo "VM already been set up to target DBR $EXISTING_DBR_VERSION."
    echo "Provisioning system environment for DBR $DBR_VERSION on top of this will most likely break things."
    echo "Start with a brand new VM if you need to work with a different DBR target environment."
    echo "Skipping DBR $DBR_VERSION System Environment provisioning step."
    exit 0
else
    echo $DBR_VERSION > "$HOME/.dbr_version"
fi

# Set versions for generic tooling
DBR_MAVEN_VERSION="3.6.3"
DBR_SBT_VERSION="1.3.12"
DBR_NODE_VERSION="v12.18.0"
DBR_RUBY_VERSION="2.7.0"

if [[ "$DBR_VERSION" == "5.5" ]]
then
    #https://docs.microsoft.com/en-us/azure/databricks/release-notes/runtime/5.5#system-environment
    DBR_JAVA_VERSION="8.0.252-open"
    DBR_PYTHON_VERSION="3.5.2" 
    DBR_R_VERSION="3.6.0"
elif [[ "$DBR_VERSION" == "6.0" ]]
then
    #https://docs.microsoft.com/en-us/azure/databricks/release-notes/runtime/6.0#system-environment
    DBR_JAVA_VERSION="8.0.252-open"
    DBR_PYTHON_VERSION="3.7.3" 
    DBR_R_VERSION="3.6.1"
elif [[ "$DBR_VERSION" == "6.1" ]]
then
    #https://docs.microsoft.com/en-us/azure/databricks/release-notes/runtime/6.1#system-environment
    DBR_JAVA_VERSION="8.0.252-open"
    DBR_PYTHON_VERSION="3.7.3" 
    DBR_R_VERSION="3.6.1"
elif [[ "$DBR_VERSION" == "6.2" ]]
then
    #https://docs.microsoft.com/en-us/azure/databricks/release-notes/runtime/6.2#system-environment
    DBR_JAVA_VERSION="8.0.252-open"
    DBR_PYTHON_VERSION="3.7.3" 
    DBR_R_VERSION="3.6.1"
elif [[ "$DBR_VERSION" == "6.3" ]]
then
    #https://docs.microsoft.com/en-us/azure/databricks/release-notes/runtime/6.3#system-environment
    DBR_JAVA_VERSION="8.0.252-open"
    DBR_PYTHON_VERSION="3.7.3" 
    DBR_R_VERSION="3.6.2"
elif [[ "$DBR_VERSION" == "6.4" ]]
then
    #https://docs.microsoft.com/en-us/azure/databricks/release-notes/runtime/6.4#system-environment
    DBR_JAVA_VERSION="8.0.252-open"
    DBR_PYTHON_VERSION="3.7.3" 
    DBR_R_VERSION="3.6.2"
elif [[ "$DBR_VERSION" == "6.5" ]]
then
    #https://docs.microsoft.com/en-us/azure/databricks/release-notes/runtime/6.5#system-environment
    DBR_JAVA_VERSION="8.0.252-open"
    DBR_PYTHON_VERSION="3.7.3" 
    DBR_R_VERSION="3.6.3"
elif [[ "$DBR_VERSION" == "6.6" ]]
then
    #https://docs.microsoft.com/en-us/azure/databricks/release-notes/runtime/6.6#system-environment
    DBR_JAVA_VERSION="8.0.252-open"
    DBR_PYTHON_VERSION="3.7.3" 
    DBR_R_VERSION="3.6.3"
elif [[ "$DBR_VERSION" == "7.0" ]]
then
    #https://docs.microsoft.com/en-us/azure/databricks/release-notes/runtime/7.0#system-environment
    DBR_JAVA_VERSION="8.0.252-open"
    DBR_PYTHON_VERSION="3.7.5" 
    DBR_R_VERSION="3.6.3"
elif [[ "$DBR_VERSION" == "7.1" ]]
then
    #https://docs.microsoft.com/en-us/azure/databricks/release-notes/runtime/7.1#system-environment
    DBR_JAVA_VERSION="8.0.252-open"
    DBR_PYTHON_VERSION="3.7.5" 
    DBR_R_VERSION="3.6.3"
elif [[ "$DBR_VERSION" == "7.2" ]]
then
    #https://docs.microsoft.com/en-us/azure/databricks/release-notes/runtime/7.2#system-environment
    DBR_JAVA_VERSION="8.0.252-open"
    DBR_PYTHON_VERSION="3.7.5" 
    DBR_R_VERSION="3.6.3"
elif [[ "$DBR_VERSION" == "7.2" ]]
else 
    DBR_LATEST_LTS="6.4"
    echo "The specified DBR version ($DBR_VERSION) is not currently supported by this script..."
    DBR_JAVA_VERSION="8.0.252-open"
    DBR_PYTHON_VERSION="3.7.3" 
    DBR_R_VERSION="3.6.2"
    DBR_VERSION=$DBR_LATEST_LTS
fi

echo "Installing environment for DBR $DBR_VERSION development..."
echo "https://docs.microsoft.com/en-us/azure/databricks/release-notes/runtime/$DBR_VERSION" > "$HOME/.databricks-environment-details"

echo "==> Installing OpenJDK..."
source "$HOME/.sdkman/bin/sdkman-init.sh"
if [[ $(sdk list java | grep "| installed  | $DBR_JAVA_VERSION" ) == "" ]]
then
    sdk install java ${DBR_JAVA_VERSION} > /dev/null 2>&1
    echo "Java: SDKMan! OpenJDK $DBR_JAVA_VERSION" >> "$HOME/.databricks-environment-details"
else
    echo "OpenJDK already installed, nothing to do."
fi

echo "==> Creating Python conda environment..."
source "$HOME/.miniconda/etc/profile.d/conda.sh"
if [[ $(conda env list  | grep "^databricks") == "" ]]
then
    conda create --yes --name databricks python=${DBR_PYTHON_VERSION} > /dev/null 2>&1
    echo "Python: $DBR_PYTHON_VERSION : conda activate databricks" >> "$HOME/.databricks-environment-details"
else
    echo "Databricks Conda environment already set up, nothing to do."
fi

echo "==> Installing R..."
if [[ $(dpkg-query -W -f='${Status}' r-${R_VERSION} 2>/dev/null | grep -c "ok installed") == "0" ]]
then
    curl -sO https://cdn.rstudio.com/r/ubuntu-2004/pkgs/r-${DBR_R_VERSION}_1_amd64.deb
    sudo apt install -y ./r-${DBR_R_VERSION}_1_amd64.deb
    rm -f r-${DBR_R_VERSION}_1_amd64.deb
    sudo ln -sfn /opt/R/${DBR_R_VERSION}/bin/R /usr/local/bin/R
    sudo ln -sfn /opt/R/${DBR_R_VERSION}/bin/Rscript /usr/local/bin/Rscript
    export RHOME=/usr/local >> $HOME/.bashrc
    mkdir -p $HOME/R/x86_64-pc-linux-gnu-library/${DBR_R_VERSION:0:3}
    echo "R: R Studio Binary $DBR_R_VERSION" >> "$HOME/.databricks-environment-details"
else
    echo "r-${DBR_R_VERSION} already installed, nothing to do." 
fi

# Scala / Waimak Development tools

echo "==> Installing Maven..."    
if [[ $(sdk list maven | grep "* $DBR_MAVEN_VERSION" ) == "" ]]
then
    sdk install maven ${DBR_MAVEN_VERSION} > /dev/null 2>&1
    echo "Maven: SDKMan! Maven $DBR_MAVEN_VERSION" >> "$HOME/.databricks-environment-details"
else
    echo "Maven already installed, nothing to do."
fi

echo "==> Installing SBT..."
if [[ $(sdk list sbt | grep "* $DBR_SBT_VERSION" ) == "" ]]
then
    sdk install sbt ${DBR_SBT_VERSION} > /dev/null 2>&1
    echo "SBT: SDKMan! SBT $DBR_SBT_VERSION" >> "$HOME/.databricks-environment-details"
else
    echo "SBT already installed, nothing to do."
fi

# Other tooling
echo "==> Installing Node.js..."
source "$HOME/.nvm/nvm.sh"
if [[ $(nvm ls --no-colors --no-alias | grep "^->     $DBR_NODE_VERSION" ) == "" ]]
then
    nvm install ${DBR_NODE_VERSION} --latest-npm > /dev/null 2>&1
    echo "Node.js: NVM Node.js $DBR_NODE_VERSION" >> "$HOME/.databricks-environment-details"
else
    echo "Node.js already installed, nothing to do."
fi

echo "==> Installing Ruby..."
source "$HOME/.rvm/scripts/rvm"
if [[ $(rvm list rubies | grep "ruby-$DBR_RUBY_VERSION") == "" ]]
then
    rvm install ruby-${DBR_RUBY_VERSION} > /dev/null 2>&1
    export PATH="$GEM_HOME/bin:$PATH" >> $HOME/.bashrc
    echo "Ruby: RVM Ruby $DBR_RUBY_VERSION" >> "$HOME/.databricks-environment-details"
else
    echo "Ruby already installed, nothing to do."
fi