#!/usr/bin/env bash
#
# Copyright 2021 by Swiss Post, Information Technology Services
#
#

set -o errexit
set -x

cd ../..
docker-compose up -d --force-recreate database
docker-compose up -d message-broker