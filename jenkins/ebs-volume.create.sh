#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source ${DIR}/../s3sync.sh

aws cloudformation create-stack --stack-name jenkins-master--volume --template-url https://jle-cloudformation.s3.amazonaws.com/jenkins/ebs-volume.yaml --region us-east-2