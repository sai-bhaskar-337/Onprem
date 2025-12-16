pipeline {
  agent any
  environment {
    IMAGE = "saibhaskar337/myapp"
    DOCKER_CREDS = "dockerhub-creds"
  }
  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }
    stage('Run tests') {
      steps {
        sh 'bash scripts/run_tests.sh'
      }
    }
    stage('Build image') {
      steps {
        script {
          GIT_SHORT = sh(script: "git rev-parse --short HEAD", returnStdout: true).trim()
          sh "bash scripts/build_image.sh ${IMAGE} ${GIT_SHORT}"
          env.IMAGE_TAG = GIT_SHORT
        }
      }
    }
    stage('Push image') {
      steps {
        withCredentials([usernamePassword(credentialsId: "${DOCKER_CREDS}", usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
          sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
          sh "docker push ${IMAGE}:${IMAGE_TAG}"
          sh "docker push ${IMAGE}:latest"
        }
      }
    }
    stage('Deploy') {
      steps {
        // For local deploy we run the remote_deploy script locally
        sh "bash scripts/remote_deploy.sh ${IMAGE} ${IMAGE_TAG}"
      }
    }
  }
  post {
    failure {
      echo "Build failed"
    }
    success {
      echo "Build succeeded: ${IMAGE}:${IMAGE_TAG}"
    }
  }
}
