#!/bin/bash
docker run --rm dbox/jobsub-test /bin/sh -c "ls /jobsub_test/jobsub/test/scripts" > jenkins_scripts
if [ "$builder" = "" ];then
    builder=$(whoami)
fi
for rel in 6 7; do  
    docker build . --build-arg rel=$rel --tag $builder/jobsub-test:sl$rel; 
done
rel=7
docker build . --build-arg rel=$rel --tag $builder/jobsub-test:latest
