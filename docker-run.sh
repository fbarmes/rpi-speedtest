#!/usr/bin/env bash

DOCKER_RUN_OPT="-d"
CONTAINER_NAME="rpi-speedtest"
DOCKER_IMAGE="rpi-speedtest"

docker run \
  ${DOCKER_RUN_OPT} \
  --name ${CONTAINER_NAME} \
  --hostname ${CONTAINER_NAME} \
  -p 9100:9100 \
  ${DOCKER_IMAGE}
