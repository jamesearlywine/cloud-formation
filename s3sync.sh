#!/bin/bash
aws s3 sync ./ s3://jle-cloudformation/ --delete --exclude ".git/*" --region us-east-2