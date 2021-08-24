#!/usr/bin/env bash

git clone https://github.com/michaelklishin/tls-gen tls-gen
cd tls-gen/basic
make PASSWORD=message-broker CN=message-broker
cp result/ca_certificate.pem ../../../base-images/resources/certs/
cp result/ca_certificate.pem result/server_certificate.pem result/server_key.pem ../../../message-broker/resources/