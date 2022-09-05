echo "Wait for route 53 service available for this resource $SERVER_NAME"
/tmp/efs-wait.sh $SERVER_NAME
echo $DOCKERHUB_PASSWORD | docker login -u $DOCKERHUB_USERNAME --password-stdin
echo $DOCKER_RUN_ENV | base64 -d | tr -s "###" '"\n' >> /tmp/docker-run.env
RUN=$(echo $DOCKER_RUN_CMD | base64 -d)
DOCKER_IMAGE=$(echo $DOCKER_RUN_IMAGE | base64 -d)
echo $DOCKER_IMAGE > /home/ubuntu/data/artifacts/docker-run-img-$PREFIX-$HOSTNAME.txt
# Necessary for special characters in image name
DOCKER_IMAGE=$(sed -e 's/[&\\/]/\\&/g; s/$/\\/' -e '$s/\\$//' <<<"$DOCKER_IMAGE")
RUN=$(sed "s/DOCKER_IMAGE/$DOCKER_IMAGE/" <<< "$RUN")
echo $RUN > /home/ubuntu/data/artifacts/docker-run-cmd-$PREFIX-$HOSTNAME.txt
$RUN > /home/ubuntu/data/artifacts/docker-run-$PREFIX-$HOSTNAME.txt