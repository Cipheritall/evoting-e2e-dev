#!/usr/bin/env bash
#
# Copyright 2021 by Swiss Post, Information Technology Services
#
#

set -o errexit
set -x

cd ../..
docker-compose up -d --force-recreate api-gateway voting-workflow extended-authentication admin-portal certificate-registry \
election-information vote-verification vp-frontend authentication voter-material orchestrator config-tools sdm-rest sdm-crypto

