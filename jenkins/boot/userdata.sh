#!/bin/bash

echo "JENKINS_HOME_VOLUME_ID: ${JENKINS_HOME_VOLUME_ID}"
echo "JENKINS_HOME_VOLUME_UUID: ${JENKINS_HOME_VOLUME_UUID}"
echo "JENKINS_MASTER_DOCKER_REPO: ${JENKINS_MASTER_DOCKER_REPO}"
echo "AWS_REGION: ${AWS_REGION}"

# apt prep
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt-get update
apt-get install -y python3 jq docker-ce systemd-docker

# update DNS entry for jenkins.earlywine.info
aws s3 cp s3://jle-cloudformation/jenkins/boot/cloudflare-dns.update.sh - | bash

# environment vars for systemd services
echo AWS_REGION=${AWS_REGION} >> /etc/environment
echo JENKINS_MASTER_DOCKER_REPO=${JENKINS_MASTER_DOCKER_REPO} >> /etc/environment

## Docker
  # /var/run/docker.sock issues
  usermod -a -G docker ubuntu
  chmod a+rw /var/run/docker.sock

  # Docker service - enabled remote api (for jenkins to dynamically spawn slave-agent containers)
  aws s3 cp s3://jle-cloudformation/jenkins/boot/systemd/docker.service /lib/systemd/system/docker.service
  systemctl enable --now docker.service

## Jenkins
  # (late volume attachment/mounting, cloudformation doesn't allow existing-volume association in spotfleet request template)
  aws ec2 attach-volume --device /dev/sdj \
  --instance-id `wget -q -O - http://169.254.169.254/latest/meta-data/instance-id` \
  --volume-id ${JENKINS_HOME_VOLUME_ID} \
  --region ${AWS_REGION}
  sleep 5
  mkdir /var/jenkins_home
  chown -R ubuntu:staff /var/jenkins_home
  chmod 766 /var/jenkins_home
  mount /dev/disk/by-uuid/${JENKINS_HOME_VOLUME_UUID} /var/jenkins_home

  # Jenkins service (run in docker container on host)
  aws s3 cp s3://jle-cloudformation/jenkins/boot/systemd/jenkins.service /etc/systemd/system/jenkins.service
  systemctl enable --now jenkins.service