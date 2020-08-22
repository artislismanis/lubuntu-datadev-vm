#!/bin/bash -e

# Read input variables
SNAP_DESCRIPTION=$1
shift
SNAP_TO_INSTALL=$1
shift

echo "==> Installing $SNAP_DESCRIPTION..."
if [[ $(snap list | grep "^$SNAP_TO_INSTALL") == "" ]]
then
    # Install snap if not already installed 
    snap install "$SNAP_TO_INSTALL" "$@"
else
    # Otherwise check for updates
    echo "$SNAP_DESCRIPTION already installed, checking for updates"
    snap refresh $SNAP_TO_INSTALL
fi