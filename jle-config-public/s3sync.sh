#!/bin/bash
aws s3 sync ./ s3://jle-config-public/ --delete --exclude ".git/*" --region us-east-2
