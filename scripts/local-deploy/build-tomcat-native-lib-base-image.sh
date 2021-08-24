#!/bin/bash
#
# Copyright 2021 by Swiss Post, Information Technology Services
#
#

IMAGE=docker.tools.pnet.ch/ev/tomcat-native-libs:evoting
docker build --no-cache --force-rm -t $IMAGE -f tomcat-native-lib.dockerfile .
docker tag $IMAGE ev/tomcat-native-libs:evoting
docker push $IMAGE