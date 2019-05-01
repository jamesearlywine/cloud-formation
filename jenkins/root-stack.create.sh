#!/bin/bash
while getopts ":s:" opt; do
  case ${opt} in
    s )
      snapshotId=$OPTARG
      ;;
    \? )
      echo "Invalid Option: -$OPTARG" 1>&2
      exit 1
      ;;
    : )
      echo "Invalid Option: -$OPTARG requires an argument" 1>&2
      exit 1
      ;;
  esac
done

# echo "snapshotId: ${snapshotId}"

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source ${DIR}/../s3sync.sh

RANDOM_BITS=$(openssl rand -base64 7 | tr -dc _A-Z-a-z-0-9 | fold -w 4 | head -n 1);
export STACKNAME="jenkins-master-${RANDOM_BITS}";

if [ -z ${snapshotId} ];
then
  aws cloudformation create-stack \
    --stack-name ${STACKNAME} \
    --template-url https://jle-cloudformation.s3.amazonaws.com/jenkins/root-stack.yaml \
    --region us-east-2 \
    --capabilities CAPABILITY_NAMED_IAM;
else
  aws cloudformation create-stack \
    --stack-name ${STACKNAME} \
    --template-url https://jle-cloudformation.s3.amazonaws.com/jenkins/root-stack.yaml \
    --region us-east-2 \
    --parameters snapshotId=${snapshotId} \
    --capabilities CAPABILITY_NAMED_IAM;
fi

