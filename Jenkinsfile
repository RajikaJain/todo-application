pipeline {
    agent any
    
    environment {
        DOCKER_CREDENTIALS = 'docker-hub-credentials' // Docker Hub credentials ID
        REPO_URL = 'https://github.com/RajikaJain/todo-application.git'
        IMAGE_NAME = 'todo-application-image'
        IMAGE_TAG = 'latest'
    }
    
    stages {
        stage('Clone Repository') {
            steps {
                script {
                    // Cloning the repository from GitHub
                    sh 'which git || echo "Git not found"'
                    sh 'git --version'
                    //sh 'git clone -b master ${REPO_URL} repo'
                    git credentialsId: 'git-credentials' , url: "$REPO_URL", branch: 'master'
                }
            }
        }
        
        stage('Build Application') {
            steps {
                script {
                    // Running Maven build with tests skipped
                    sh 'mvn clean install -DskipTests'
                }
            }
        }
        
        stage('Build Docker Image') {
            steps {
                script {
                    // Build Docker image and tag it with the provided name
                    sh 'docker build -t $IMAGE_NAME:$IMAGE_TAG .'
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    // Log in to Docker Hub and push the image
                    withCredentials([usernamePassword(credentialsId: "$DOCKER_CREDENTIALS", usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                        sh 'echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin'
                        sh 'docker tag $IMAGE_NAME:$IMAGE_TAG rajikajain2035/$IMAGE_NAME:$IMAGE_TAG'
                        sh 'docker push rajikajain2035/$IMAGE_NAME:$IMAGE_TAG'
                    }
                }
            }
        }

        stage('Deploy with Docker Compose') {
            steps {
                script {
                    // Deploy using Docker Compose
                    sh 'docker compose up -d'
                }
            }
        }

        stage('Verify Services') {
            steps {
                script {
                    // Verifying that the services are up and running
                    sh 'docker compose ps'
                }
            }
        }

        stage('Clean Workspace') {
            steps {
                script {
                    // Cleaning up workspace by removing generated files
                    sh 'rm -rf *'
                }
            }
        }
    }
    
    post {
        always {
            // Clean up the workspace after pipeline run
            cleanWs()
        }
    }
}
