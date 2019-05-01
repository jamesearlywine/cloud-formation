#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source ${DIR}/../s3sync.sh

aws cloudformation update-stack --stack-name jenkins--iam-instance-profile --template-url https://jle-cloudformation.s3.amazonaws.com/jenkins/iam-instance-profile.yaml --region us-east-2 --capabilities CAPABILITY_NAMED_IAM