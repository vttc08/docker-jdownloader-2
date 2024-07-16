#!/bin/sh

set -e # Exit immediately if a command exits with a non-zero status.
set -u # Treat unset variables as an error.

# Make sure mandatory directories exist.
mkdir -p /config/logs

# Set default configuration on new install.
if [ ! -f /config/mcaselector.jar ]; then
    echo "Binary not found, copying default binary."
    cp /defaults/mcaselector.jar /config/mcaselector.jar
else
    echo "Skipping binary copy, binary already exists."
fi

if [ ! -f /config/xdg/config/mcaselector/settings.json ]; then
    echo "Settings not found, copying default settings."
    mkdir -p /config/xdg/config/mcaselector
    cp /defaults/settings.json /config/xdg/config/mcaselector/settings.json
else
    echo "Skipping settings copy, settings already exist."
fi

# Take ownership of the output directory.
take-ownership --not-recursive /world

# vim:ft=sh:ts=4:sw=4:et:sts=4
