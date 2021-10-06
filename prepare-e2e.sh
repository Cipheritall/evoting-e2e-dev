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

##########################
########## Main ##########
##########################

reset_testdata
define_compose_file_options
rebuild_service_images

echo "Starting all services"
docker-compose ${composeFileOptions} stop
docker-compose ${composeFileOptions} up -d --force-recreate
docker-compose ${composeFileOptions} logs --follow | grep --colour "SEVERE\|ERROR"
