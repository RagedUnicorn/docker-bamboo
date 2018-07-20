#!/bin/bash
# @author Michael Wiesendanger <michael.wiesendanger@gmail.com>
# @description build script for docker-bamboo container

set -euo pipefail

WD="${PWD}"

# variable setup
DOCKER_BAMBOO_TAG="ragedunicorn/bamboo"
DOCKER_BAMBOO_NAME="bamboo"
DOCKER_BAMBOO_DATA_VOLUME="bamboo_data"
DOCKER_BAMBOO_LOGS_VOLUME="bamboo_logs"

# get absolute path to script and change context to script folder
SCRIPTPATH="$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)"
cd "${SCRIPTPATH}"

echo "$(date) [INFO]: Building container: ${DOCKER_BAMBOO_NAME}"

# build bamboo container
docker build -t "${DOCKER_BAMBOO_TAG}" ../

# check if bamboo data volume already exists
docker volume inspect "${DOCKER_BAMBOO_DATA_VOLUME}" > /dev/null 2>&1

if [ $? -eq 0 ]; then
  echo "$(date) [INFO]: Reusing existing volume: ${DOCKER_BAMBOO_DATA_VOLUME}"
else
  echo "$(date) [INFO]: Creating new volume: ${DOCKER_BAMBOO_DATA_VOLUME}"
  docker volume create --name "${DOCKER_BAMBOO_DATA_VOLUME}" > /dev/null
fi

# check if bamboo logs volume already exists
docker volume inspect "${DOCKER_BAMBOO_LOGS_VOLUME}" > /dev/null 2>&1

if [ $? -eq 0 ]; then
  echo "$(date) [INFO]: Reusing existing volume: ${DOCKER_BAMBOO_LOGS_VOLUME}"
else
  echo "$(date) [INFO]: Creating new volume: ${DOCKER_BAMBOO_LOGS_VOLUME}"
  docker volume create --name "${DOCKER_BAMBOO_LOGS_VOLUME}" > /dev/null
fi

cd "${WD}"
