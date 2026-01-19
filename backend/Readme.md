### step1: update application.properties
### step2: build docker image
### step3: push image to dockerhub
### step4: modify backend.yaml - change image name
### step5: apply backend.yaml and svc.yaml
### step 6: copy backend svc link and paste to frontend/.env file


```jenkinsfile
pipeline {
    agent any

    tools {
        jdk 'jdk17'
        maven 'maven'
        dockerTool 'docker'
    }

    environment {
        DOCKER_IMAGE = "abhipraydh96/std-test-be"
        IMAGE_TAG    = "${BUILD_NUMBER}"
    }

    stages {

        stage('Code-Pull') {
            steps {
                git branch: 'main', url: 'https://github.com/abhipraydhoble/project-studentapp-three-tier-final.git'
            }
        }

        stage('Build') {
            steps {
                dir('backend') {
                    sh 'mvn clean package -DskipTests'
                }
            }
        }

        

        stage('Docker-Build') {
            steps {
                dir('backend') {
                    sh """
                      docker build -t ${DOCKER_IMAGE}:${IMAGE_TAG} .
                    """
                }
            }
        }

        stage('Docker-Push') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'docker-cred',
                        usernameVariable: 'DOCKER_USER',
                        passwordVariable: 'DOCKER_PASS'
                    )
                ]) {
                    sh """
                      echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                      docker push ${DOCKER_IMAGE}:${IMAGE_TAG}
                    """
                }
            }
        }

       stage('Deploy') {
    steps {
        withCredentials([
            file(credentialsId: 'config-file', variable: 'KUBECONFIG'),
            [$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-cred']
        ]) {
            sh """
                sed -i 's|image:.*|image: ${DOCKER_IMAGE}:${IMAGE_TAG}|' backend/deployment.yaml

                kubectl apply -f backend/configmap.yaml
                kubectl apply -f backend/secret.yaml
                kubectl apply -f backend/deployment.yaml
                kubectl apply -f backend/service.yaml
            """
        }
    }
}

    }
}
```
