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
                    bat 'docker-compose up -d --build'
                    bat 'ping 127.0.0.1 -n 11 >nul'
                    bat 'curl -f http://localhost:80 || exit /b 1'
                }
            }
        }
        
        // REMOVE OR COMMENT THIS STAGE TO KEEP CONTAINER RUNNING
        // stage('Cleanup') {
        //     steps {
        //         dir('app') {
        //             bat 'docker-compose down'
        //         }
        //     }
        // }
    }

    post {
        always {
            echo 'Pipeline finished.'
            // Also remove this line to keep container
            // bat 'docker system prune -f'
        }
    }
}