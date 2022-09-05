#!/bin/bash
echo "Preparing the charts"
wget https://github.com/nmonvisualizer/nmonvisualizer/releases/download/2021-04-04/NMONVisualizer_2021-04-04.jar
java -jar NMONVisualizer_2021-04-04.jar com.ibm.nmon.ReportGenerator ./data/artifacts/nmon/

cp charts.py data/artifacts/nmon/
cd data/artifacts/nmon/ || exit
python charts.py

cd ~ || exit
#Disabling this code as ssh from ec2-bastion to ec2-docker modules is not working
#echo "Stopping docker on jahia nodes"
#hostnames=( "jahia" "jahia-browsing-a" "jahia-browsing-b" )
#for host in "${hostnames[@]}"
#do
#  ssh ubuntu@${host}.A.B.REDACTED.com "docker stop docker_container && docker cp docker_container:/tmp/${host}-recording.jfr /home/ubuntu/data/artifacts/results/${host}"
#done

echo "Display disk capacity"
df -h

echo "Copying the artifacts locally prior to zipping"
mkdir -p artifacts-dump/
cp -r data/artifacts/* artifacts-dump/

echo "Display size of the artifacts"
du -h -d 1 artifacts-dump/

echo "Zipping all artifacts files"
zip -r all_artifacts.zip artifacts-dump/*

echo "Copying the results json"
cp data/artifacts/results/jmeter-runs.json data/artifacts/
touch LOG_FILES_ARE_IN_all_artifacts.zip

echo "Removing jmeter reports"
rm -rf data/artifacts/results

echo "Removing logs (which can get pretty huge for Jahia"
echo "Logs are kept in all_artifacts.zip"
rm -rf data/artifacts/*.log.txt

echo "Moving the all_artifacts file to artifacts folder"
mv all_artifacts.zip data/artifacts/
