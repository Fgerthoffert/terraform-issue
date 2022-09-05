#!/usr/bin/env bash
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
    sleep 10
  done
  echo "Found provisioning_done. Restarting Jahia"
  docker exec docker_container touch /var/jahia/repository/reindex
  docker restart docker_container
fi
