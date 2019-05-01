#!/bin/bash

# apt prep
apt-get update

# aws cli bundle dependencies
apt-get install -y unzip python-minimal

# install aws cli from bundle
mkdir /opt/aws
curl "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o "/opt/aws/awscli-bundle.zip"
cd /opt/aws
unzip awscli-bundle.zip
/opt/aws/awscli-bundle/install -i /opt/aws
chown -R ubuntu:staff /opt/aws
chmod -R 777 /opt/aws/bin
ln -s /opt/aws/bin/aws /usr/bin/aws