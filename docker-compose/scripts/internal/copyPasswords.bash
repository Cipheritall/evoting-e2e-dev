#!/bin/bash

usage() {
  cat <<-EOF
    usage: $0 SERVICE

    Copy passwords stored in the ./conf/password/keys_tmp to ./conf/password/tenant.

    SERVICE:
      authentication, election-information, vote-verification, orchestrator
EOF
}

if [[ $# -ne 1 ]]; then
  echo "Illegal number of parameters, exactly one needed."
  usage
  exit 2
fi

# On Windows with GIT bash we need to use 'winpty' when in interactive mode (-it).
if [ "$OSTYPE" == "msys" ]; then
  PREFIX="winpty"
else
  PREFIX=""
fi

SERVICE=$1

case $SERVICE in
authentication)
  $PREFIX docker exec -it authentication bash -c 'cp ./conf/password/keys_tmp/tenant_AU_100.properties ./conf/password/tenant/'
  ;;
*)
  echo -n "Invalid service name."
  ;;
esac
