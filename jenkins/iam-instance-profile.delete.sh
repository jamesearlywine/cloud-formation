#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source ${DIR}/../s3sync.sh

aws cloudformation create-stack --stack-name jenkins--iam-instance-profile --template-url https://jle-cloudformation.s3.amazonaws.com/policy/iam-instance-profile-admin-s3.yaml --region us-east-2 --capabilities CAPABILITY_NAMED_IAM