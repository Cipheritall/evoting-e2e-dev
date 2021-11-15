#!/usr/bin/env bash
#
# Copyright 2021 by Swiss Post, Information Technology Services
#
#
# Available arguments :
#   -d the database to use, either h2, h2-internal or oracle. Required.
set -o errexit

load_argument() {
  while getopts d: option; do
    case "${option}" in

    d) DATABASE=${OPTARG} ;;
    *)
      echo "Unknown option ${OPTARG}. Process is ending..."
      die 1
      ;;
    esac
  done

  if [ "${DATABASE}" != "h2" ] && [ "${DATABASE}" != "h2-internal" ] && [ "${DATABASE}" != "oracle" ]; then
    echo "Database argument must be part of h2, h2-internal or oracle."
    exit 1
  fi
}
set -o errexit
set -x

cd ../..
load_argument "$@"
docker-compose -f docker-compose.common-internal.yml -f docker-compose."${DATABASE}".yml build
