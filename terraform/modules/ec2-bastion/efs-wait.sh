#!/bin/bash
mount_dns="${1}". 
mount_ip=$(dig +short $mount_dns)

while [ "$mount_ip" = "" ]
do
  echo "Unable to resolve EFS name ${1}, pausing for 1s"
  sleep 1
  mount_ip=$(dig +short $mount_dns)
done

echo "Was able to resolve ${1} to ${mount_ip}"