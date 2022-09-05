#!/usr/bin/env bash
if "${3}" eq "true"; then
  echo "Wait for route 53 service available for this resource $SERVER_NAME"
  /tmp/efs-wait.sh $SERVER_NAME
  echo "Waiting for docker daemon to start"
  while ! docker info ; do
  sleep 5
  done
  echo "Docker daemon has started"
  while  ! docker ps --format "{{.Image}}" | grep -E '.*' ; do
  echo "Waiting for docker_container to start"
  sleep 10;
  done
  echo "Docker container has started"
  if docker ps --format "{{.Image}}" | grep -o 'jahia/jahia'; then
  while [ ! -f "/home/ubuntu/data/artifacts/results/provisioning_done" ]; do
    echo "Waiting for provisioning_done"
    sleep 60
  done
  echo "Found provisioning_done. Starting JFR and crontab"
  docker exec docker_container jcmd 1 JFR.start maxage=4h maxsize=1G filename="/tmp/${1}"-recording.jfr dumponexit=true disk=true name="${1}"
  fi
fi
