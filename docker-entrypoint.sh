#!/bin/sh
# @author Michael Wiesendanger <michael.wiesendanger@gmail.com>
# @description launch script for confluence

set -euo pipefail

# start bamboo in foreground
exec su-exec ${BAMBOO_USER} /opt/atlassian/bamboo/bin/start-bamboo.sh -fg
