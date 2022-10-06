#!/usr/bin/env bash
#
# Copyright 2021 by Swiss Post, Information Technology Services
#
#

set -o errexit
set -x

cd ../../..
docker-compose stop -t 60 database
docker-compose stop message-broker