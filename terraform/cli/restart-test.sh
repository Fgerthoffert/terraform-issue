echo "Use this script with caution, it could be that even after restarted, injectors servers not be available from executor"
echo "In that case use terraform to remove injectors and executor to recreate them"

for injector  in 1 4 5 6; do
  echo "restart injector $injector"
  ssh -o StrictHostKeyChecking=no ubuntu@jmeter-injector${injector}.jperf.B.REDACTED.com 'docker stop docker_container; docker rm docker_container;docker pull jahia/core-perf-test:jmeter-execution; /tmp/docker-run.sh'
done
echo "wait for injectors to be ready"
sleep 60
echo "restart coordinator without import"
ssh -o StrictHostKeyChecking=no ubuntu@jmeter-coordinator.jperf.B.REDACTED.com 'docker stop docker_container; docker pull jahia/core-perf-test:jmeter-execution;docker rm docker_container;export DO_IMPORT=false;/tmp/docker-run.sh'