#!/usr/bin/env bash
#
# Copyright 2021 by Swiss Post, Information Technology Services
#
#

# Script to setup the docker dev environment for an end to end.
#

set -o errexit

source $EVOTING_DOCKER_HOME/copy-evoting-version-in-env-file.sh

reset_testdata() {
  rm -rf testdata
  cp -r testdata-external testdata
}

# Arg 1: prompt
# Arg 2: yes action
# Arg 3: no action
confirm_operation() {
  if [ "$#" -ne 3 ]; then
    echo "$#"
    echo "Not enough arguments provided to confirm_operation."
    exit 1;
  fi
  echo -n "$1" "[y/N]"
  read -r input
  case "$input" in
    y | Y) bash -c "$2" ;;
    n | N | *) bash -c "$3"; exit 0 ;;
  esac
}

rebuild_service_images() {
  echo "Rebuilding docker services images"
  docker-compose ${composeFileOptions} build
}

define_compose_file_options() {
  composeFileOptions="-f docker-compose.common.yml -f docker-compose.h2.yml"
}

prepare_multiple_sdm() {
  echo "Unzipping secure-data-manager. Please wait..."

  cd ..

  rm -rf secure-data-manager*

  evoting_version=$(mvn help:evaluate -Dexpression=project.version -q -DforceStdout -f e-voting/pom.xml)
  SDM_LOCAL_PATH=./secure-data-manager-package-$evoting_version/win64/sdm

  unzip "e-voting/secure-data-manager/packaging/target/secure-data-manager-package-$evoting_version.zip" -d ./secure-data-manager-package-$evoting_version

  echo "Creating secure-data-manager files and directories. Please wait..."
  mkdir -p secure-data-manager-$evoting_version
  mkdir -p $SDM_LOCAL_PATH/sdmConfig

  cp -R evoting-e2e-dev/testdata/sdm/config/. $SDM_LOCAL_PATH/config
  cp -R evoting-e2e-dev/testdata/sdm/application-level-security/signed-http-headers/keystore/. $SDM_LOCAL_PATH/config/keystore
  cp -R evoting-e2e-dev/testdata/sdm/systemKeys/. $SDM_LOCAL_PATH/systemKeys
  cp -R evoting-e2e-dev/testdata/sdm/direct-trust/. $SDM_LOCAL_PATH/direct-trust
  cp evoting-e2e-dev/testdata/sdm/config/database_password.properties $SDM_LOCAL_PATH/sdmConfig/database_password.properties
  cp -R evoting-e2e-dev/testdata/sdm/tenant/. $SDM_LOCAL_PATH/tenant

  mkdir -p $SDM_LOCAL_PATH/smart-cards

  echo "Configuring global secure-data-manager instances properties. Please wait..."
  printf "\nadmin.portal.enabled=false" >>$SDM_LOCAL_PATH/../application.properties
  printf "\nsmartcards.profile=e2e-manual" >>$SDM_LOCAL_PATH/../application.properties
  printf "\nrole.isConfig=false" >>$SDM_LOCAL_PATH/../application.properties
  printf "\nrole.isTally=false" >>$SDM_LOCAL_PATH/../application.properties
  printf "\nimport.export.zip.password=sdmpassword" >>$SDM_LOCAL_PATH/../application.properties
  printf "\nchoiceCodeGenerationChunkSize=10" >>$SDM_LOCAL_PATH/../application.properties

  echo "Creating config, online and tally secure-data-manager. Please wait..."
  cp -R ./secure-data-manager-package-$evoting_version ./secure-data-manager-$evoting_version/ConfigSDM
  cp -R ./secure-data-manager-package-$evoting_version ./secure-data-manager-$evoting_version/TallySDM
  mv ./secure-data-manager-package-$evoting_version ./secure-data-manager-$evoting_version/OnlineSDM

  echo "Configuring specific secure-data-manager instances properties. Please wait..."
  sed -i 's/role.isConfig=false/role.isConfig=true/g' ./secure-data-manager-$evoting_version/ConfigSDM/win64/application.properties
  sed -i 's/role.isTally=false/role.isTally=true/g' ./secure-data-manager-$evoting_version/TallySDM/win64/application.properties

  printf "\nvoting.portal.enabled=false" >>./secure-data-manager-$evoting_version/ConfigSDM/win64/application.properties
  printf "\nvoting.portal.enabled=false" >>./secure-data-manager-$evoting_version/TallySDM/win64/application.properties

  echo "Setup completed! You can now run the OnlineSDM 'SecureDataManager.exe' application!"

  cd evoting-e2e-dev
}

##########################
########## Main ##########
##########################

reset_testdata
define_compose_file_options
rebuild_service_images

echo "Starting all services"
docker-compose ${composeFileOptions} stop
docker-compose ${composeFileOptions} up -d --force-recreate

echo "Extracting and configuring the three secure-data-manager instances (OnlineSDM, ConfigSDM, TallySDM)."
prepare_multiple_sdm

echo "Starting to listen on docker container logs..."
docker-compose ${composeFileOptions} logs --follow | grep --colour "SEVERE\|ERROR\|WARN"
