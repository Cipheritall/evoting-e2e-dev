#!/usr/bin/env bash
#
# (c) Copyright 2022 by Swiss Post, Information Technology Services
#
#

set -o errexit

while [[ $# -gt 0 ]]; do
  case $1 in
    -h|--help)
      echo "Usage: prepare-multiple-sdm.sh"
      echo "Extracts and configures the three secure-data-manager instances (synchronisation, configuration, decryption)."
      echo
      echo "NOTE: This script is automatically called by the 'e2e.sh' script."
      exit 0
      ;;
    -*|--*)
      echo "Unknown option $1"
      exit 1
      ;;
  esac
done

evoting_version=$(mvn help:evaluate -Dexpression=project.version -q -DforceStdout -f e-voting/pom.xml)

SDM_LOCAL_PATH=./secure-data-manager-package-$evoting_version/win64/sdm

echo "Unzipping secure-data-manager. Please wait..."
unzip "e-voting/secure-data-manager/packaging/target/secure-data-manager-package-$evoting_version.zip" -d ./secure-data-manager-package-$evoting_version

echo "Creating secure-data-manager files and directories. Please wait..."
mkdir -p secure-data-manager-$evoting_version
mkdir -p $SDM_LOCAL_PATH/integration
mkdir -p $SDM_LOCAL_PATH/sdmConfig

cp -R evoting-e2e-dev/testdata/sdm/config/. $SDM_LOCAL_PATH/config
cp -R evoting-e2e-dev/testdata/sdm/application-level-security/signed-http-headers/keystore/. $SDM_LOCAL_PATH/config/keystore
cp -R evoting-e2e-dev/testdata/sdm/electionEvents/. $SDM_LOCAL_PATH/integration/electionEvents
cp -R evoting-e2e-dev/testdata/tools/file-converter/Post_E2E_DEV/output/. $SDM_LOCAL_PATH/integration/electionEvents/Post_E2E_DEV/output
cp -R evoting-e2e-dev/testdata/tools/file-converter/Post_E2E_DEV_1000/output/. $SDM_LOCAL_PATH/integration/electionEvents/Post_E2E_DEV_1000/output
cp -R evoting-e2e-dev/testdata/tools/file-converter/Post_E2E_DEV_10000/output/. $SDM_LOCAL_PATH/integration/electionEvents/Post_E2E_DEV_10000/output
cp -R evoting-e2e-dev/testdata/tools/DIS/Post_E2E_DEV/output/batch/. $SDM_LOCAL_PATH/integration/electionEvents/Post_E2E_DEV/input
cp -R evoting-e2e-dev/testdata/tools/DIS/Post_E2E_DEV_1000/output/batch/. $SDM_LOCAL_PATH/integration/electionEvents/Post_E2E_DEV_1000/input
cp -R evoting-e2e-dev/testdata/tools/DIS/Post_E2E_DEV_10000/output/batch/. $SDM_LOCAL_PATH/integration/electionEvents/Post_E2E_DEV_10000/input
cp -R evoting-e2e-dev/testdata/sdm/systemKeys/. $SDM_LOCAL_PATH/systemKeys
cp -R evoting-e2e-dev/testdata/sdm/direct-trust/. $SDM_LOCAL_PATH/direct-trust
cp evoting-e2e-dev/testdata/sdm/config/database_password.properties $SDM_LOCAL_PATH/sdmConfig/database_password.properties
cp -R evoting-e2e-dev/testdata/sdm/tenant/. $SDM_LOCAL_PATH/tenant

mkdir -p $SDM_LOCAL_PATH/smart-cards

echo "Configuring global secure-data-manager instances properties. Please wait..."
printf "\nadmin.portal.enabled=false" >>$SDM_LOCAL_PATH/../application.properties
printf "\nsmartcards.profile=e2e" >>$SDM_LOCAL_PATH/../application.properties
printf "\nrole.isConfig=false" >>$SDM_LOCAL_PATH/../application.properties
printf "\nrole.isTally=false" >>$SDM_LOCAL_PATH/../application.properties
printf "\nimport.export.zip.password=sdmpassword" >>$SDM_LOCAL_PATH/../application.properties
printf "\nchoiceCodeGenerationChunkSize=10" >>$SDM_LOCAL_PATH/../application.properties

echo "Creating configuration, decryption, and synchronisation secure-data-manager. Please wait..."
cp -R ./secure-data-manager-package-$evoting_version ./secure-data-manager-$evoting_version/configuration
cp -R ./secure-data-manager-package-$evoting_version ./secure-data-manager-$evoting_version/decryption
mv ./secure-data-manager-package-$evoting_version ./secure-data-manager-$evoting_version/synchronisation

echo "Configuring specific secure-data-manager instances properties. Please wait..."
sed -i 's/role.isConfig=false/role.isConfig=true/g' ./secure-data-manager-$evoting_version/configuration/win64/application.properties
sed -i 's/role.isTally=false/role.isTally=true/g' ./secure-data-manager-$evoting_version/decryption/win64/application.properties

printf "\nvoting.portal.enabled=false" >>./secure-data-manager-$evoting_version/configuration/win64/application.properties
printf "\nvoting.portal.enabled=false" >>./secure-data-manager-$evoting_version/decryption/win64/application.properties

echo "Setup completed! You can now run the synchronisation 'SecureDataManager.exe' application!"
