#!/bin/bash -e

# Read input variables
PACKAGE_DESCRIPTION=$1
shift

echo "==> Installing $PACKAGE_DESCRIPTION..."
apt-get -y install "$@"