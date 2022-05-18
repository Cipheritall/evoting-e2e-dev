#!/usr/bin/env bash
#
# (c) Copyright 2022 Swiss Post Ltd.
#
#

if [ -z "$1" ]; then
  echo "Please enter Secure Data Manager path until /sdm folder!"
  exit 1
fi

SDM_LOCAL_PATH=$1

mkdir -p $SDM_LOCAL_PATH/integration
mkdir -p $SDM_LOCAL_PATH/sdmConfig

cp -R ../../testdata/sdm/config/. $SDM_LOCAL_PATH/config
cp ../../testdata/sdm/config/database_password.properties $SDM_LOCAL_PATH/sdmConfig/database_password.properties
cp -R ../../testdata/sdm/systemKeys/. $SDM_LOCAL_PATH/systemKeys
cp -R ../../testdata/sdm/direct-trust/. $SDM_LOCAL_PATH/direct-trust
cp -R ../../testdata/sdm/application-level-security/signed-http-headers/keystore/. $SDM_LOCAL_PATH/config/keystore
cp -R ../../testdata/sdm/electionEvents/. $SDM_LOCAL_PATH/integration/electionEvents
cp -R ../../testdata/sdm/tenant/. $SDM_LOCAL_PATH/tenant
cp -R ../../testdata/tools/file-converter/. $SDM_LOCAL_PATH/integration/electionEvents
cp -R ../../testdata/tools/DIS/Post_E2E_DEV/output/batch/. $SDM_LOCAL_PATH/integration/electionEvents/Post_E2E_DEV/input
cp -R ../../testdata/tools/DIS/Post_E2E_DEV_1000/output/batch/. $SDM_LOCAL_PATH/integration/electionEvents/Post_E2E_DEV_1000/input
cp -R ../../testdata/tools/DIS/Post_E2E_DEV_10000/output/batch/. $SDM_LOCAL_PATH/integration/electionEvents/Post_E2E_DEV_10000/input

mkdir -p $SDM_LOCAL_PATH/smart-cards

printf "\nadmin.portal.host=http://localhost:8015" >>$SDM_LOCAL_PATH/../application.properties
printf "\nsmartcards.profile=e2e" >>$SDM_LOCAL_PATH/../application.properties
printf "\ndirect.trust.keystore.location="$SDM_LOCAL_PATH"/direct-trust/signing_keystore_sdm.jks" >>$SDM_LOCAL_PATH/../application.properties
printf "\ndirect.trust.keystore.password.location="$SDM_LOCAL_PATH"/direct-trust/signing_pw_sdm.txt" >>$SDM_LOCAL_PATH/../application.properties

echo "You can now run the Secure Data Manager.exe application!"
