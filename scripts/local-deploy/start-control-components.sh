#!/usr/bin/env bash
#
# Copyright 2021 by Swiss Post, Information Technology Services
#
#

set -o errexit
set -x

cd ../..
docker-compose up -d --force-recreate return-codes-1 return-codes-2 return-codes-3 return-codes-4 \
distributed-mixing-1 distributed-mixing-2 distributed-mixing-3
