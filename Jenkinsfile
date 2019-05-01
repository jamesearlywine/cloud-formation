pipeline {
  agent any
  stages {
    stage('Deploy to S3') {
      steps {
        script {
          if(env.BRANCH_NAME == 'master') {
            sh 'aws s3 sync ./ s3://jle-cloudformation/ --delete --exclude ".git/*" --region us-east-2'
          }
        }
      }
    }
  }
  post {
    always {
      deleteDir()
    }
  }
}
