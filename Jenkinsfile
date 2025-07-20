pipeline {
    agent any
    
    environment {
        // Update the main app image name to match the deployment file
        DOCKER_IMAGE_NAME = 'lavanyakotha/docker-python'
        DOCKER_IMAGE_TAG = "${BUILD_NUMBER}"
        GITHUB_CREDENTIALS = credentials('github-credentials')
        GIT_BRANCH = "main"
    }
    
    stages {
        stage('Checkout') {
            steps {
                git url: 'https://github.com/Lavanyakotha/Docker-Python.git', branch: 'main'
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
        
       stage('Update Kubernetes Manifests') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'github-credentials', usernameVariable: 'GIT_USER', passwordVariable: 'GIT_PASS')]) {
                        sh '''
                            # Clean workspace if needed
                            rm -rf Docker-Python

                            # Clone the Kubernetes manifests repo
                            git clone https://Lavanyakotha:****@github.com/Lavanyakotha/Docker-Python.git
                            cd Docker-Python

                            # Set Git identity
                            git config user.name "k.lavanya543@gmail.com"
                            git config user.email "k.lavanya543@gmail.com"

                            # Update the image tag in the manifest file
                            sed -i "s|image: .*/your-app:.*|image: ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG}|" kubernetes/deployment.yaml

                            # Commit and push changes
                            git add kubernetes/deployment.yaml
                            git commit -m "Update image tag to ${DOCKER_IMAGE_TAG}"
                            git push origin main
                        '''
                    }
                }
            }
        }
}
}
