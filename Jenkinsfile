// Jenkinsfile — webhook / SCM trigger restarts TrueID Portal on the host via pm2.
//
// Setup (once on agent3):
//   1. Permanent checkout: ~/apps/trueid-portal
//   2. Job: Pipeline from SCM → https://github.com/SebberSky/trueid-portal
//      Branch */main · Script Path: Jenkinsfile · agent label: agent3
//   3. GitHub repo → Settings → Webhooks → Add webhook:
//      Payload URL: http://<JENKINS_URL>/github-webhook/
//      Content type: application/json
//      Events: Just the push event
//   4. Or Build Now manually anytime

pipeline {
  agent { label 'agent3' }

  options {
    timestamps()
    disableConcurrentBuilds()
    buildDiscarder(logRotator(numToKeepStr: '20'))
  }

  triggers {
    githubPush()
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Restart portal (pm2)') {
      steps {
        sh '''
          export PATH="/opt/homebrew/bin:/usr/local/bin:$HOME/.local/bin:$PATH"
          chmod +x scripts/jenkins-restart.sh
          bash scripts/jenkins-restart.sh
        '''
      }
    }
  }

  post {
    success {
      echo 'Portal restarted via pm2. Local: http://localhost:5170/'
    }
    failure {
      echo 'Restart failed — check Node/pm2 on the agent and port 5170.'
    }
  }
}
