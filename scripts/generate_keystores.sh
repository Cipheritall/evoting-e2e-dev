#!/usr/bin/bash

components=( sdm_config sdm_tally voting_server control_component_1 control_component_2 control_component_3 control_component_4 )

# generate a keystore for each components
for component in ${components[@]}
do
	echo $component
	java -jar $EVOTING_HOME/tools/config-cryptographic-parameters-tool/target/config-cryptographic-parameters-tool-*.jar \
       -keystore \
       -alias $component \
       -out "./output/$component" \
       -valid_from $(date +"%d/%m/%Y") \
       -valid_until $(date +"%d/%m/%Y" -d "+5 years") \
       -certificate_common_name $component \
       -certificate_country switzerland \
       -certificate_state neuchatel \
       -certificate_organisation swiss-post \
       -certificate_locality neuchatel
done

# add all certificates to each keystore
for main_component in ${components[@]}
do
	for component_to_add in ${components[@]}
  do
    if [ "$main_component" != "$component_to_add" ]; then
  	  echo "add certificate of $component_to_add to the keystore of $main_component"
  	  password =
      keytool -import \
              -alias $component_to_add \
              -file "./output/$component_to_add/signing_certificate_$component_to_add.crt" \
      		    -keystore "./output/$main_component/signing_keystore_$main_component.jks" \
      		    -storepass:file "./output/$main_component/signing_pw_$main_component.txt" \
      		    -noprompt
    fi
  done
done
