#!/bin/bash

# environment variable JENKINS_EC2_SPOT_STACKNAME is defined during the ec2-instance-spot.create.sh script .. stores the last-used stackname
aws cloudformation delete-stack --stack-name ${JENKINS_EC2_SPOT_STACKNAME} --region us-east-2