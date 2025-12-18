pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                // This checks out the code from your Git repository
                checkout scm
            }
        }

        stage('Build & Test') {
            steps {
                dir('apache-php') {
                    // Start the services defined in docker-compose.yml
                    sh 'docker-compose up -d --build'
                    // Add a simple test, e.g., check if the web service is reachable
                    sh 'sleep 10 && curl -f http://localhost:80 || exit 1'
                }
            }
        }

        stage('Cleanup') {
            steps {
                dir('apache-php') {
                    // Stop and remove the running containers
                    sh 'docker-compose down'
                }
            }
        }
    }

    post {
        always {
            echo 'Pipeline finished.'
            // Optional: Clean up unused Docker images to save space
            sh 'docker system prune -f'
        }
    }
}