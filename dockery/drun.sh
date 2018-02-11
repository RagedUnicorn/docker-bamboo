#!/bin/bash
# @author Michael Wiesendanger <michael.wiesendanger@gmail.com>
# @description run script for docker-bamboo container

# abort when trying to use unset variable
set -o nounset

WD="${PWD}"

# variable setup
DOCKER_BAMBOO_TAG="ragedunicorn/bamboo"
DOCKER_BAMBOO_NAME="bamboo"
DOCKER_BAMBOO_DATA_VOLUME="bamboo_data"
DOCKER_BAMBOO_LOGS_VOLUME="bamboo_logs"
DOCKER_BAMBOO_ID=0

# get absolute path to script and change context to script folder
SCRIPTPATH="$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)"
cd "${SCRIPTPATH}"

# check if there is already an image created
docker inspect ${DOCKER_BAMBOO_NAME} &> /dev/null

if [ $? -eq 0 ]; then
  # start container
  docker start "${DOCKER_BAMBOO_NAME}"
else
  ## run image:
  # -v mount volume
  # -p expose port
  # -d run in detached mode
  # --name define a name for the container(optional)
  DOCKER_BAMBOO_ID=$(docker run \
  -v ${DOCKER_BAMBOO_DATA_VOLUME}:/var/atlassian/bamboo \
  -v ${DOCKER_BAMBOO_LOGS_VOLUME}:/opt/atlassian/bamboo/logs \
  -p 8085:8085 \
  -dit \
  --name "${DOCKER_BAMBOO_NAME}" "${DOCKER_BAMBOO_TAG}")
fi

if [ $? -eq 0 ]; then
  # print some info about containers
  echo "$(date) [INFO]: Container info:"
  docker inspect -f '{{ .Config.Hostname }} {{ .Name }} {{ .Config.Image }} {{ .NetworkSettings.IPAddress }}' ${DOCKER_BAMBOO_NAME}
else
  echo "$(date) [ERROR]: Failed to start container - ${DOCKER_BAMBOO_NAME}"
fi

cd "${WD}"
