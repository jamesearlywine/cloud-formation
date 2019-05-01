# How to use these cloudformation templates/scripts/etc.
- Create Network Interface .. examine it's Output properties for ENI ID and EIP
  - Update the EC2-Instance cloudformation parameter default to use the ENI ID for NetworkInterfaceId
  - @Note - uses the security groups found in ../policy:
    - security-group-ssh-from-home.yaml
    - securitygroup-txp-8900-all.yaml
  - @Todo - Update DNS entry for jenkins to point to the EIP

- Create Volume .. examine it's Output properties for VolumeId
  - Volume can be created from a SnapshotId (helpful for moving across regions, etc).
  - Update the EC2-Instance cloudformation parameter default to use the VolumeId

- Create IAM Instance Profile
  - use the resultant ID in the EC2 template

- Create EC2 Instance
  - while debugging, create these things seperately and initialize EC2 Instance with the IDs for:
    - NetworkInterface
    - Volume
    - IamInstanceProfile

- Create EC2 Spot Instance

# Todo
- Create complete stack
  - Volume (from Snapshot - DeletionPolicy: Snapshot)
  - IAMInstanceProfile
  - EC2 SpotFleetRequest/Instance
- Install nginx proxy (for accessing Jenkins via https)
  - with SSH certificate

- How to create a jenkins job that uses github webhook, without creating an organization that scans and runs all Jenkinsfile jobs?
  - https://github.com/gitbucket/gitbucket/wiki/Setup-Jenkins-Multibranch-Pipeline-and-Organization

- Todo items that will use AWS Lambda functions:
  - Create CustomResource to Create/Update DNS A Record jenkins.earlywine.info
  - Create CustomResource to Create/Update github webhooks for repos (maybe)
  - Get Jenkins to create new snapshot of jenkins_home volume every 24 hours
    - Detect/Remove previously-created jenkins_home volume snapshots
  - Get Jenkins working behind nginx reverse-proxy for https
    - will do this later, uses AWS::CertificateManager::Certificate
      - should issue wildcard for domain
      - should use DNS cname to validate domain ownership
        - should use cloudformation CustomResource + LambdaFunction (or Jenkins) to update DNS in Cloudflare

# Notes
- During debugging
  - Network Interface, IamInstanceProfile, and Volume are created independently, so that
    - the EC2 instance can be deleted and created as needed very quickly
      - without losing any work, and
      - without having to update DNS entries (so webhooks aren't broken, etc.)
    - Cloudflare DNS A-Record jenkins.earlywine.info needs to point to the EIP of the network interface
- Jenkins web interface is exposed on port 8900

