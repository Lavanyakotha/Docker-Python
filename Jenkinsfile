pipeline {
    agent any
    
    environment {
        // Update the main app image name to match the deployment file
        DOCKER_IMAGE_NAME = 'Lavanyakotha/Docker-Python'
        DOCKER_IMAGE_TAG = "${BUILD_NUMBER}"
        GITHUB_CREDENTIALS = credentials('github-credentials')
        GIT_BRANCH = "master"
    }
    
    
        stage('Clone Repository') {
            steps {
                script {
                    clone("https://github.com/Lavanyakotha/Docker-Python.git","Docker-Python")
                }
            }
        }
        
        stage('Build Docker Images') {
            parallel {
                stage('Build Main App Image') {
                    steps {
                        script {
                            docker_build(
                                imageName: env.DOCKER_IMAGE_NAME,
                                imageTag: env.DOCKER_IMAGE_TAG,
                                dockerfile: 'Dockerfile',
                                context: '.'
                            )
                        }
                    }
                }
                
               
            }
        }
             
        stage('Push Docker Images') {
            parallel {
                stage('Push Main App Image') {
                    steps {
                        script {
                            docker_push(
                                imageName: env.DOCKER_IMAGE_NAME,
                                imageTag: env.DOCKER_IMAGE_TAG,
                                credentials: 'docker-hub-credentials'
                            )
                        }
                    }
                }
                
                
            }
        }
        
        // Add this new stage
        stage('Update Kubernetes Manifests') {
            steps {
                script {
                    update_k8s_manifests(
                        imageTag: env.DOCKER_IMAGE_TAG,
                        manifestsPath: 'kubernetes',
                        gitCredentials: 'github-credentials',
                        gitUserName: 'Jenkins CI',
                        gitUserEmail: 'k.lavanya543@gmail.com'
                    )
                }
            }
        }
    
}
