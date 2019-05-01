#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source ${DIR}/../s3sync.sh

RANDOM_BITS=$(openssl rand -base64 7 | tr -dc _A-Z-a-z-0-9 | fold -w 4 | head -n 1);
export JENKINS_EC2_SPOT_STACKNAME="jenkins-master--ec2-instance-spot-${RANDOM_BITS}";

aws cloudformation create-stack --stack-name ${JENKINS_EC2_SPOT_STACKNAME} \
  --template-url https://jle-cloudformation.s3.amazonaws.com/jenkins/ec2-instance-spot.yaml \
  --region us-east-2  \
  --capabilities CAPABILITY_NAMED_IAM