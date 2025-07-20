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
        
        stage('Deploy to EC2') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'Docker', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sshagent(credentials: ['ec2-keypair']) {
                        sh '''
                        ssh -o StrictHostKeyChecking=no ec2-user@54.205.51.22 "
                            docker login -u $DOCKER_USER -p $DOCKER_PASS
                            docker pull $DOCKER_IMAGE_NAME:$DOCKER_IMAGE_TAG
                            docker stop flask-app || true
                            docker rm flask-app || true
                            docker run -d -p 80:80 --name flask-app $DOCKER_IMAGE_NAME:$DOCKER_IMAGE_TAG
                        "
                        '''
                    }
                }
            }
        }
    }
}
