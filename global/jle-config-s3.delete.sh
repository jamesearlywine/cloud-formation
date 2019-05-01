#!/bin/bash
aws s3 rm s3://jle-config/ --recursive
aws cloudformation delete-stack --stack-name s3-config-storage