pipeline {
    agent any

    environment {
        DOCKER_IMAGE_NAME = 'lavanyakotha/docker-python'
        DOCKER_IMAGE_TAG = "${BUILD_NUMBER}"
        GITHUB_CREDENTIALS = credentials('github-credentials')
        GIT_BRANCH = "main"
        EC2_HOST = "54.205.51.22" // Replace with your EC2 public IP
        EC2_USER = "ec2-user"         // or "ubuntu" for Ubuntu AMIs
    }

    stages {
        stage('Checkout') {
            steps {
                git url: 'https://github.com/Lavanyakotha/Docker-Python.git', branch: "${GIT_BRANCH}"
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    dockerImage = docker.build("${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG}")
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', 'Docker') {
                        dockerImage.push()
                    }
                }
            }
        }

        stage('Deploy to EC2') {
            steps {
                sshagent (credentials: ['ec2-keypair']) {
                    sh """
                        ssh -o StrictHostKeyChecking=no ${EC2_USER}@${EC2_HOST} << EOF
                            docker pull ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG}
                            docker stop flask-app || true
                            docker rm flask-app || true
                            docker run -d -p 80:80 --name flask-app ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG}
                        EOF
                    """
                }
            }
        }
    }
}
