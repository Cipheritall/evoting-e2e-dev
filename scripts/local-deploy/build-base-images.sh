#!/usr/bin/env bash
#
# Copyright 2021 by Swiss Post, Information Technology Services
#
#

BINDIR=$(dirname $BASH_SOURCE)
cd $BINDIR
cd ../../base-images
docker build --build-arg DOCKER_REGISTRY=$DOCKER_REGISTRY -t ev/oraclexe:18.4.0-xe -f oraclexe.dockerfile .
docker build --build-arg DOCKER_REGISTRY=$DOCKER_REGISTRY -t ev/rabbitmq:3.7 -f rabbitmq.dockerfile .
docker build --build-arg DOCKER_REGISTRY=$DOCKER_REGISTRY -t ev/java:1.8 -f java.dockerfile .
docker build --build-arg DOCKER_REGISTRY=$DOCKER_REGISTRY --no-cache --force-rm -t ev/tomcat-native-libs:evoting -f tomcat-native-lib.dockerfile .
docker build --build-arg DOCKER_REGISTRY=$DOCKER_REGISTRY -t ev/tomee:8 -f tomee.dockerfile .
docker build --build-arg DOCKER_REGISTRY=$DOCKER_REGISTRY -t ev/apache:2.4.37 -f apache.dockerfile .
docker build --build-arg DOCKER_REGISTRY=$DOCKER_REGISTRY -t ev/tomcat:8.5.72 -f tomcat.dockerfile .
