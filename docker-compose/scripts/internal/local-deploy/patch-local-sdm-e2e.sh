#!/usr/bin/env bash
#
# (c) Copyright 2022 Swiss Post Ltd.
#
#

# Check parameters
if [[ -z "$1" ]]; then
  echo "Please enter the path where you extracted Secure Data Manager"
  exit 1
fi

# Set working path
SDM_LOCAL_PATH=$(cygpath.exe --mixed "$1")
echo "Selected SDM folder is $SDM_LOCAL_PATH"
SDM_FOLDER="$SDM_LOCAL_PATH/sdm"

# Check if already patch
if [[ -d "$SDM_FOLDER/config" || -d "$SDM_FOLDER/smart-cards" ]]; then
  echo "Looks like you already have applied the patch."
  read -p "Do you really want to run it again? (y/N)?" RESP
  if [[ "$RESP" != "y" && "$RESP" != "Y" ]]; then
    echo "No -> Exiting."
    exit 1
  fi
fi

# Patch sdm folder
mkdir -p "$SDM_FOLDER/integration"
mkdir -p "$SDM_FOLDER/sdmConfig"

cp -R "$EVOTING_DOCKER_HOME/docker-compose/testdata/sdm/config/." "$SDM_FOLDER/config"
cp "$EVOTING_DOCKER_HOME/docker-compose/testdata/sdm/config/database_password.properties" "$SDM_FOLDER/sdmConfig/database_password.properties"
cp -R "$EVOTING_DOCKER_HOME/docker-compose/testdata/sdm/systemKeys/." "$SDM_FOLDER/systemKeys"
cp -R "$EVOTING_DOCKER_HOME/docker-compose/testdata/sdm/direct-trust/." "$SDM_FOLDER/direct-trust"
cp -R "$EVOTING_DOCKER_HOME//testdata/sdm/application-level-security/signed-http-headers/keystore/." "$SDM_FOLDER/config/keystore"
cp -R "$EVOTING_DOCKER_HOME/docker-compose/testdata/sdm/electionEvents/." "$SDM_FOLDER/integration/electionEvents"
cp -R "$EVOTING_DOCKER_HOME/docker-compose/testdata/sdm/tenant/." "$SDM_FOLDER/tenant"
cp -R "$EVOTING_DOCKER_HOME/docker-compose/testdata/tools/file-converter/." "$SDM_FOLDER/integration/electionEvents"
cp -R "$EVOTING_DOCKER_HOME/docker-compose/testdata/tools/encryption-parameters/." "$SDM_FOLDER/config/encryption-parameters"
cp -R "$EVOTING_DOCKER_HOME/docker-compose/testdata/tools/DIS/Post_E2E_DEV/output/batch/." "$SDM_FOLDER/integration/electionEvents/Post_E2E_DEV/input"
cp -R "$EVOTING_DOCKER_HOME/docker-compose/testdata/tools/DIS/Post_E2E_DEV_1000/output/batch/." "$SDM_FOLDER/integration/electionEvents/Post_E2E_DEV_1000/input"
cp -R "$EVOTING_DOCKER_HOME/docker-compose/testdata/tools/DIS/Post_E2E_DEV_10000/output/batch/." "$SDM_FOLDER/integration/electionEvents/Post_E2E_DEV_10000/input"

mkdir -p "$SDM_FOLDER/smart-cards"

# Patch application properties

printf "\nadmin.portal.host=http://localhost:8015" >>"$SDM_LOCAL_PATH/application.properties"
printf "\nsmartcards.profile=e2e-manual" >>"$SDM_LOCAL_PATH/application.properties"
printf "\nrole.isConfig=true" >>"$SDM_LOCAL_PATH/application.properties"
printf "\nrole.isTally=true" >>"$SDM_LOCAL_PATH/application.properties"
printf "\nimport.export.zip.password=sdmpassword" >>"$SDM_LOCAL_PATH/application.properties"
printf "\nchoiceCodeGenerationChunkSize=10" >>"$SDM_LOCAL_PATH/application.properties"

echo "You can now run the Secure Data Manager.exe application!"
