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

        stage('Update Kubernetes Manifests') {
            steps {
                script {
                    // ✅ Update deployment.yaml image tag and apply to Kubernetes
                    sh """
                    echo "Updating Kubernetes manifests with image tag: ${DOCKER_IMAGE_TAG}"
                    sed -i 's|image:.*|image: ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG}|g' kubernetes/deployment.yaml
                    echo "Updated deployment.yaml:"
                    cat kubernetes/deployment.yaml

                    echo "Applying manifests to Kubernetes cluster..."
                    kubectl apply -f kubernetes/
                    """
                }
            }
        }
    }
}
