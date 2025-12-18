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
                    // Build and start container
                    bat 'docker-compose up -d --build'
                    
                    // Wait 10 seconds for container to start (using ping instead of timeout)
                    bat 'ping 127.0.0.1 -n 11 >nul'
                    
                    // Test if service is responding
                    bat 'curl -f http://localhost:80 || exit /b 1'
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