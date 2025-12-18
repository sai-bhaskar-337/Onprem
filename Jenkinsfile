pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build & Test') {
            steps {
                dir('app') {
                    // Use 'bat' instead of 'sh' for Windows
                    bat 'docker-compose up -d --build'
                    bat 'timeout /t 10 && curl -f http://localhost:80 || exit /b 1'
                }
            }
        }

        stage('Cleanup') {
            steps {
                dir('app') {
                    bat 'docker-compose down'
                }
            }
        }
    }

    post {
        always {
            echo 'Pipeline finished.'
            bat 'docker system prune -f'
        }
    }
}