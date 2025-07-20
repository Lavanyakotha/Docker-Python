pipeline {
    agent any

    environment {
        // Docker image name and tag
        DOCKER_IMAGE_NAME = 'lavanyakotha/docker-python'
        DOCKER_IMAGE_TAG = "${BUILD_NUMBER}"
        GITHUB_CREDENTIALS = credentials('github-credentials')
        GIT_BRANCH = "main"
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

       
    }
}
