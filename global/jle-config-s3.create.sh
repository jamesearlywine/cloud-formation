#!/bin/bash
aws cloudformation create-stack --stack-name s3-config-storage --template-url https://jle-cloudformation.s3.amazonaws.com/global/jle-config-s3.yaml --region us-east-2