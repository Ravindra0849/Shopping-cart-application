pipeline {
    agent any
    
    tools {
        jdk "jdk17"
        maven "maven3"
    }
    
    environment {
        DOCKER_USERNAME = "ravisree900"
    }

    stages {
        stage('Clean Workspace') {
            steps {
                cleanWs()
            }
        }
        
        stage('Download Code from github') {
            steps {
                git "https://github.com/Ravindra0849/Shopping-cart-application.git"
            }
        }
        
        stage('Code Compile') {
            steps {
                sh "mvn compile"
            }
        }
        
        stage('Unit Test') {
            steps {
                sh "mvn test"
            }
        }
        
        stage('Mvn Verify Test') {
            steps {
                sh "mvn verify"
            }
        }
        
        stage('Build the Artifact') {
            steps {
                sh "mvn clean install package"
            }
        }
        
        stage('Scan the Current Dir files') {
            steps {
                sh "trivy fs . > trivyfs.txt"
            }
        }
        
        stage('Docker Image Creation') {
            steps {
                script {
                    withDockerRegistry(credentialsId: 'docker-credentials', toolName: 'docker') {
                       def JOB = env.JOB_NAME.toLowerCase()    //covert job name into lower case
                        sh "docker build -t '${JOB}:${BUILD_NUMBER}' ." 
                        sh "docker tag '${JOB}:${BUILD_NUMBER}' '${DOCKER_USERNAME}/${JOB}:${BUILD_NUMBER}'"
                    }
                }
            }
        }
        
        stage('Scan the Docker Image') {
            steps {
                script {
                    def JOB = env.JOB_NAME.toLowerCase()    //covert job name into lower case
                    sh " trivy image '${DOCKER_USERNAME}/${JOB}:${BUILD_NUMBER}' > trivyimage.txt"
                }
            }
        }
        
        stage('Docker Image Push to Registry') {
            steps {
                script {
                    withDockerRegistry(credentialsId: 'docker-credentials', toolName: 'docker') {
                       def JOB = env.JOB_NAME.toLowerCase()    //covert job name into lower case
                        sh "docker push '${DOCKER_USERNAME}/${JOB}:${BUILD_NUMBER}'"
                    }
                }
            }
        }

        stage('Create Docker Container') {
            steps {
                script {
                    withDockerRegistry(credentialsId: 'docker-credentials', toolName: 'docker') {
                       def JOB = env.JOB_NAME.toLowerCase()    //covert job name into lower case
                        sh "docker run --name shopping -d -p 8081:8080 '${DOCKER_USERNAME}/${JOB}:${BUILD_NUMBER}'"
                    }
                }
            }
        }
    }
}
