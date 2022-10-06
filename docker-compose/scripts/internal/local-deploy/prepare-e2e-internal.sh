#!/usr/bin/env bash
#
# Copyright 2021 by Swiss Post, Information Technology Services
#
#

#
# Script to setup the docker dev environment for an end to end.
#
# Available arguments :
#   -d the database to use, either h2 or oracle. Required.
set -o errexit
#set -x

source $EVOTING_DOCKER_HOME/docker-compose/scripts/copy-evoting-version-in-env-file.sh

load_argument() {
  while getopts d: option; do
      case "${option}"
      in
        d) DATABASE=${OPTARG} ;;
    *)
      echo "Unknown option ${OPTARG}. Process is ending..."
      die 1
      ;;
      esac
    done

  if [ "${DATABASE}" != "h2" ] && [ "${DATABASE}" != "oracle" ] && [ "${DATABASE}" != "h2-internal" ]; then
    echo "Database argument must be either h2, h2-internal or oracle."
    exit 1
  fi
}

reset_testdata() {
  rm -rf $EVOTING_DOCKER_HOME/docker-compose/testdata
  cp -r $EVOTING_DOCKER_HOME/testdata/testdata-internal $EVOTING_DOCKER_HOME/docker-compose/testdata
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
  if [ "${DATABASE}" == "oracle" ]; then
    if grep -q '^\s*image: ev\/database-snap' docker-compose.oracle.yml; then
      echo "Snapshot detected in compose file. Building all images except the database"
      docker-compose ${composeFileOptions} build admin-portal api-gateway authentication certificate-registry extended-authentication election-information voter-material \
      vote-verification voting-workflow message-broker-orchestrator voter-portal sdm-backend \
      message-broker-1 message-broker-2 message-broker-3 \
      control-component-1 control-component-2 control-component-3 control-component-4
      return 0
    fi
  fi
  docker-compose ${composeFileOptions} build
}

check_db_snapshot() {
  snapshot_count=$(docker images "ev/$SNAPSHOT_NAME:${EVOTING_VERSION}" -q | wc -l)
  if [ "$snapshot_count" -ne 1 ]; then
    confirm_operation "Cannot find database snapshot image, the startup will take a long time, are you sure you want to proceed? [y/N]" \
      'echo "Starting database without snapshot."' \
      'echo "Exiting."'
  else
    echo "Using database snapshot image."
    sed -i "s/#image: ev\/$SNAPSHOT_NAME:\${EVOTING_VERSION}/image: ev\/$SNAPSHOT_NAME:\${EVOTING_VERSION}/" docker-compose.oracle.yml
    sed -i "s/image: ev\/database:\${EVOTING_VERSION}/#image: ev\/database:\${EVOTING_VERSION}/" docker-compose.oracle.yml
  fi
}

define_compose_file_options() {
  composeFileOptions="-f ${EVOTING_DOCKER_HOME}/docker-compose/docker-compose.common-internal.yml -f ${EVOTING_DOCKER_HOME}/docker-compose/docker-compose.${DATABASE}.yml"
}

##########################
########## Main ##########
##########################

SNAPSHOT_NAME="database-snap"

cd $EVOTING_DOCKER_HOME/docker-compose/
load_argument "$@"
reset_testdata
define_compose_file_options
if [ "${DATABASE}" == "oracle" ]; then
  check_db_snapshot
fi
rebuild_service_images

echo "Starting all services"
docker-compose ${composeFileOptions} stop
docker-compose ${composeFileOptions} up -d --force-recreate
docker-compose ${composeFileOptions} logs --no-color --follow | sed -r "s/\x1b\[[0-9;]*m?//g" | grep --colour -w "SEVERE\|ERROR\|WARN"
