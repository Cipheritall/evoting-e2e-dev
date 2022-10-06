#!/usr/bin/env bash
#
# (c) Copyright 2022 Swiss Post Ltd.
#
# Script to create 1 local SDM for testing the vote in a close to real situation.
#

# Exit if any line failed
set -e

DIR=$(cygpath.exe --mixed "$1")
EV_HOME=$(cygpath.exe --mixed "$EVOTING_HOME")
EV_E2E=$(cygpath.exe --mixed "$EVOTING_DOCKER_HOME")

DIR_NAME="sdm-online-setup-tally"

# Prepare target directory (exist or create, is empty)
if [ -d "$DIR" ]
then
	if [ "$(ls -A "$DIR")" ]; then
     echo "The target directory is not empty. Exiting."
     exit 1
	else
    echo "$DIR exist and is empty."
	fi
else
  mkdir -p "$DIR"
	echo "Directory $DIR created."
fi

# Validate the e-voting package is present
if compgen -G "$EV_HOME/packaging/target/swisspost-package-*.zip" > /dev/null; then
  echo "E-voting package found."
else
  echo "Impossible to find the packaged SDM. Please run the e-voting packaging. Exiting."
  exit 2
fi

if [[ -d "$EV_HOME/packaging/target/swisspost-package" ]]; then
  echo "E-voting package already extracted. Skip extraction."
else
  echo "Start extraction of e-voting package. This may take a while."
  unzip -o "$EV_HOME/packaging/target/swisspost-package-*.zip" -d "$EV_HOME/packaging/target/swisspost-package" > /dev/null
  echo "Extraction finished."
fi

# Create the all in one SDM
mkdir "$DIR/$DIR_NAME"
echo "Start extraction of SDM. This may take a while."
unzip -o "$EV_HOME/packaging/target/swisspost-package/secure-data-manager-win64-package" -d "$DIR/$DIR_NAME" > /dev/null
/bin/bash "$EV_E2E/docker-compose/scripts/internal/local-deploy/patch-local-sdm-e2e.sh" "$DIR/$DIR_NAME" > /dev/null
echo "Extraction finished."

# Try to stop SDM present in docker
docker stop sdm-backend > /dev/null || :
echo "SDM in docker stopped."

echo "You can now run one of the all in one Secure Data Manager.exe application!"
