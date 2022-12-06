pipeline {
    agent {
        label 'docker'
    }
    environment {
        DOCKER_HUB_CREDENTIALS = credentials('DOCKER_HUB_CREDENTIALS')
        DOCKER_IMAGE_TAG       = "olivertembo/php:${env.JOB_BASE_NAME.toLowerCase()}"
    }
    stages {
        stage ('checkout') {
            steps {
                checkout scm
            }
        }

        stage ('build docker image') {
            steps {
                sh "docker build --squash --tag \"${DOCKER_IMAGE_TAG}\" ."
            }
        }

        stage ('push docker image') {
            when {
                anyOf {
                    branch 'master'; buildingTag()
                }
            }
            steps {
                sh "docker login --username=\"${DOCKER_HUB_CREDENTIALS_USR}\" --password=\"${DOCKER_HUB_CREDENTIALS_PSW}\""
                sh "docker push \"${DOCKER_IMAGE_TAG}\""
            }
        }

        stage ('remove docker image') {
            when {
                not {
                    branch 'master';
                }
                not {
                    buildingTag()
                }
            }
            steps {
                sh "docker rmi \"${DOCKER_IMAGE_TAG}\""
            }
        }

        stage ('clean up workspace') {
            steps {
                cleanWs()
            }
        }
    }
}
