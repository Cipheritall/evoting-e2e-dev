#!/usr/bin/env bash
#
# Copyright 2021 by Swiss Post, Information Technology Services
#
#

set -o errexit
set -x

cd ../..
docker-compose up -d --force-recreate control-components-1 control-components-2 control-components-3 control-components-4 