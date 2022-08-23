#!/usr/bin/env bash
#
# Copyright 2021 by Swiss Post, Information Technology Services
#
#

set -o errexit

set_evoting_version() {
  EVOTING_VERSION=$(grep -oP '(?<=<version>)[0-9]+\.[0-9]+\.[0-9]+(?=\.[0-9]+(\-SNAPSHOT[0-9]*)?</version>)' $EVOTING_HOME/pom.xml)
  sed -i -r "s/^(EVOTING_VERSION=).*/\1${EVOTING_VERSION}/" $EVOTING_DOCKER_HOME/.env
}
set_evoting_version
