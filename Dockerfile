FROM ragedunicorn/openjdk:1.0.2-jre-stable

LABEL com.ragedunicorn.maintainer="Michael Wiesendanger <michael.wiesendanger@gmail.com>"

#     ____                  __
#    / __ )____ _____ ___  / /_  ____  ____
#   / __  / __ `/ __ `__ \/ __ \/ __ \/ __ \
#  / /_/ / /_/ / / / / / / /_/ / /_/ / /_/ /
# /_____/\__,_/_/ /_/ /_/_.___/\____/\____/

# image args
ARG BAMBOO_USER=bamboo
ARG BAMBOO_GROUP=bamboo

ENV \
  BAMBOO_VERSION=6.5.0 \
  SU_EXEC_VERSION=0.2-r0 \
  CURL_VERSION=7.61.0-r0 \
  GIT_VERSION=2.15.2-r0 \
  OPENSSH_VERSION=7.5_p1-r8 \
  BASH_VERSION=4.4.19-r1

ENV \
  BAMBOO_USER="${BAMBOO_USER}" \
  BAMBOO_GROUP="${BAMBOO_GROUP}" \
  BAMBOO_HOME=/var/atlassian/bamboo \
  BAMBOO_INSTALL=/opt/atlassian/bamboo \
  BAMBOO_DATA_DIR=/var/atlassian/bamboo \
  BAMBOO_LOGS_DIR=/opt/atlassian/bamboo/logs

# explicitly set user/group IDs
RUN addgroup -S "${BAMBOO_GROUP}" -g 9999 && adduser -S -G "${BAMBOO_GROUP}" -u 9999 "${BAMBOO_USER}"

RUN \
  set -ex; \
  apk add --no-cache \
    su-exec="${SU_EXEC_VERSION}" \
    curl="${CURL_VERSION}" \
    git="${GIT_VERSION}" \
    openssh="${OPENSSH_VERSION}" \
    bash="${BASH_VERSION}"; \
  mkdir -p "${BAMBOO_HOME}"; \
  mkdir -p "${BAMBOO_HOME}/lib"; \
  chmod -R 700 "${BAMBOO_HOME}"; \
  chown -R "${BAMBOO_USER}":"${BAMBOO_GROUP}" "${BAMBOO_HOME}"; \
  mkdir -p "${BAMBOO_INSTALL}"; \
  curl -Ls "https://www.atlassian.com/software/bamboo/downloads/binary/atlassian-bamboo-${BAMBOO_VERSION}.tar.gz" \
    | tar -zx --directory  "${BAMBOO_INSTALL}" --strip-components=1 --no-same-owner; \
  curl --location "https://jdbc.postgresql.org/download/postgresql-9.4.1212.jar" \
    -o "${BAMBOO_INSTALL}/lib/postgresql-9.4.1212.jar"; \
  chmod -R 700 "${BAMBOO_INSTALL}"; \
  chown -R "${BAMBOO_USER}":"${BAMBOO_GROUP}" "${BAMBOO_INSTALL}"; \
  sed --in-place 's/^# umask 0027$/umask 0027/g' "${BAMBOO_INSTALL}/bin/setenv.sh";

# add healthcheck script
COPY docker-healthcheck.sh /

# add launch script
COPY docker-entrypoint.sh /

RUN \
  chmod 755 /docker-entrypoint.sh && \
  chmod 755 /docker-healthcheck.sh

# expose web and agent ports
EXPOSE 8085
EXPOSE 54663

# Set volume mount points for installation and home directory. Changes to the
# home directory needs to be persisted as well as parts of the installation directory due to eg. logs.
VOLUME ["${BAMBOO_DATA_DIR}", "${BAMBOO_LOGS_DIR}"]

ENTRYPOINT ["/docker-entrypoint.sh"]
