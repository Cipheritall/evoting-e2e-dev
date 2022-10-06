#!/usr/bin/env bash
#
# (c) Copyright 2022 Swiss Post Ltd.
#
# Script to create 3 local SDM for testing the vote in a "real" situation.
#

# Exit if any line failed
set -e

DIR=$(cygpath.exe --mixed "$1")
EV_HOME=$(cygpath.exe --mixed "$EVOTING_HOME")
EV_E2E=$(cygpath.exe --mixed "$EVOTING_DOCKER_HOME")

DIR_NAME_SETUP="sdm-setup"
DIR_NAME_ONLINE="sdm-online"
DIR_NAME_TALLY="sdm-tally"

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

# Create a generic sdm in a tmp folder
mkdir "$DIR/sdm"
echo "Start extraction of SDM. This may take a while."
unzip -o "$EV_HOME/packaging/target/swisspost-package/secure-data-manager-win64-package" -d "$DIR/sdm" > /dev/null
/bin/bash "$EV_E2E/docker-compose/scripts/internal/local-deploy/patch-local-sdm-e2e.sh" "$DIR/sdm" > /dev/null
echo "Extraction finished."

# Create SDM setup
echo "Start creation of SDM setup. This may take a while."
cp -R "$DIR/sdm" "$DIR/$DIR_NAME_SETUP"
sed -i 's|role.isTally=true|role.isTally=false|g' "$DIR/$DIR_NAME_SETUP/application.properties"
sed -i 's|admin.portal.host=http://localhost:8015|admin.portal.host=http://dummy|g' "$DIR/$DIR_NAME_SETUP/application.properties"
printf "\nadmin.portal.enabled=false" >> "$DIR/$DIR_NAME_SETUP/application.properties"
printf "\nvoting.portal.enabled=false" >> "$DIR/$DIR_NAME_SETUP/application.properties"
printf "\nvoting.portal.host=http://dummy" >> "$DIR/$DIR_NAME_SETUP/application.properties"
echo "SDM setup created"

# Create SDM tally
echo "Start creation of SDM tally. This may take a while."
cp -R "$DIR/sdm" "$DIR/$DIR_NAME_TALLY"
sed -i 's|role.isConfig=true|role.isConfig=false|g' "$DIR/$DIR_NAME_TALLY/application.properties"
sed -i 's|admin.portal.host=http://localhost:8015|admin.portal.host=http://dummy|g' "$DIR/$DIR_NAME_TALLY/application.properties"
printf "\nadmin.portal.enabled=false" >> "$DIR/$DIR_NAME_TALLY/application.properties"
printf "\nvoting.portal.enabled=false" >> "$DIR/$DIR_NAME_TALLY/application.properties"
printf "\nvoting.portal.host=http://dummy" >> "$DIR/$DIR_NAME_TALLY/application.properties"
echo "SDM tally created"

# Create SDM online
echo "Start creation of SDM online."
mv "$DIR/sdm" "$DIR/$DIR_NAME_ONLINE"
sed -i 's|role.isTally=true|role.isTally=false|g' "$DIR/$DIR_NAME_ONLINE/application.properties"
sed -i 's|role.isConfig=true|role.isConfig=false|g' "$DIR/$DIR_NAME_ONLINE/application.properties"
echo "SDM sync created"

# Try to stop SDM present in docker
docker stop sdm-backend > /dev/null
echo "SDM in docker stopped." || :

echo "You can now run one of the 3 Secure Data Manager.exe application!"
