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

set_evoting_version() {
  EVOTING_VERSION=$(grep -oP '(?<=<version>)[0-9]+\.[0-9]+\.[0-9]+(?=\.[0-9]+(\-SNAPSHOT)?</version>)' $EVOTING_HOME/pom.xml)
  sed -i -r "s/^(EVOTING_VERSION=).*/\1 ${EVOTING_VERSION}/" $EVOTING_DOCKER_HOME/.env
}
set_evoting_version