#cloud-formation
- personaldev-jenkins
  - https://jle-cloudformation.s3.amazonaws.com/jenkins/jenkins-root.stack.yaml
    - /jenkins/create-stack.sh (CLI script to create the jenkins stack)
    - KeypairName Default Value: 'JenkinsServer'

  - https://jle-cloudformation.s3.amazonaws.com/personaldev/jenkins-spot-request-persistent.json (deprecated)
- personaldev-rds (migrated from us-west-2 snapshot)
  - https://jle-cloudformation.s3.amazonaws.com/personaldev/rds-instance-from-us-west-snapshot.json
- james.earlywine.info s3 website bucket
  - https://jle-cloudformation.s3.amazonaws.com/personaldev/james.earlywine.info-s3_bucket_host.json
- indykaraoke.com s3 static content bucket
  - https://jle-cloudformation.s3.amazonaws.com/personaldev/indykaroake.com-s3_static_content.json
- vendvortex.com s3 static content bucket
  - https://jle-cloudformation.s3.amazonaws.com/personaldev/vendvortex.com-s3_static_content.json
- esilogix.com s3 website bucket
  - https://jle-cloudformation.s3.amazonaws.com/personaldev/esilogix.com-s3_bucket_host.json

..running create/update/delete scripts, must run from the root folder.
