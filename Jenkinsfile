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
                    update_k8s_manifests(
                        imageTag: env.DOCKER_IMAGE_TAG,
                        manifestsPath: 'kubernetes',
                        gitCredentialsId: 'github-credentials',   // ✅ changed
                        gitUsernameVar: 'GIT_USER',               // ✅ added
                        gitPasswordVar: 'GIT_PAT',                // ✅ added
                        gitUserName: 'Jenkins CI',
                        gitUserEmail: 'k.lavanya543@gmail.com'
                    )
                }
            }
        }
}
}
