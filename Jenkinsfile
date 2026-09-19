pipeline {

    agent {
        label 'webserver'
    }

    options {
        disableConcurrentBuilds()

        buildDiscarder(
            logRotator(
                numToKeepStr: '20',
                artifactNumToKeepStr: '10'
            )
        )

        skipDefaultCheckout(true)
        timestamps()
        timeout(time: 30, unit: 'MINUTES')
    }

    environment {
        DOCKER_FRONTEND_REPO = 'victorajadi/artisan-mart-frontend'
        DOCKER_BACKEND_REPO  = 'victorajadi/artisan-mart-backend'

        DOCKER_FRONTEND_IMAGE = "${DOCKER_FRONTEND_REPO}:${BUILD_NUMBER}"
        DOCKER_BACKEND_IMAGE  = "${DOCKER_BACKEND_REPO}:${BUILD_NUMBER}"

        DOCKER_CREDENTIALS = 'DockerHub'

        GIT_REPO   = 'https://github.com/VictorAjadi/DevOps-Demo-Artisan_Mart.git'
        GIT_BRANCH = 'main'
    }

    stages {

        stage('Clean Workspace') {
            steps {
                deleteDir()
            }
        }

        stage('Checkout') {
            steps {
                git(
                    branch: "${GIT_BRANCH}",
                    url: "${GIT_REPO}",
                    changelog: true,
                    poll: false
                )
            }
        }

        stage('Docker Login') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: "${DOCKER_CREDENTIALS}",
                        usernameVariable: 'DOCKER_USERNAME',
                        passwordVariable: 'DOCKER_PASSWORD'
                    )
                ]) {
                    sh '''#!/bin/bash
                        set -euo pipefail

                        echo "Logging into Docker Hub..."

                        echo "${DOCKER_PASSWORD}" | docker login \
                            --username "${DOCKER_USERNAME}" \
                            --password-stdin

                        echo "Docker login successful."
                    '''
                }
            }
        }

        stage('Build Frontend Image') {
            steps {
                sh '''#!/bin/bash
                    set -euo pipefail

                    echo "Building frontend image..."

                    docker build \
                        --pull \
                        --tag "${DOCKER_FRONTEND_IMAGE}" \
                        --file frontend/Dockerfile \
                        frontend

                    echo "Frontend image built:"
                    docker image inspect "${DOCKER_FRONTEND_IMAGE}" \
                        --format '{{.RepoTags}}'
                '''
            }
        }

        stage('Build Backend Image') {
            steps {
                sh '''#!/bin/bash
                    set -euo pipefail

                    echo "Building backend image..."

                    docker build \
                        --pull \
                        --tag "${DOCKER_BACKEND_IMAGE}" \
                        --file backend/Dockerfile \
                        backend

                    echo "Backend image built:"
                    docker image inspect "${DOCKER_BACKEND_IMAGE}" \
                        --format '{{.RepoTags}}'
                '''
            }
        }

        stage('Push Images') {
            parallel {

                stage('Push Frontend') {
                    steps {
                        sh '''#!/bin/bash
                            set -euo pipefail

                            echo "Pushing frontend image..."
                            docker push "${DOCKER_FRONTEND_IMAGE}"
                        '''
                    }
                }

                stage('Push Backend') {
                    steps {
                        sh '''#!/bin/bash
                            set -euo pipefail

                            echo "Pushing backend image..."
                            docker push "${DOCKER_BACKEND_IMAGE}"
                        '''
                    }
                }
            }
        }

        stage('Deploy') {
            steps {
                echo "Images successfully built and pushed."

                sh '''#!/bin/bash
                    set -euo pipefail

                    echo "========================================"
                    echo "Deployment image versions"
                    echo "========================================"

                    echo "Frontend:"
                    echo "${DOCKER_FRONTEND_IMAGE}"

                    echo ""
                    echo "Backend:"
                    echo "${DOCKER_BACKEND_IMAGE}"

                    echo ""
                    echo "Deployment step ready."
                '''
            }
        }
    }

    post {

        success {
            echo """
            ========================================
            BUILD SUCCESSFUL
            ========================================

            Frontend:
            ${DOCKER_FRONTEND_IMAGE}

            Backend:
            ${DOCKER_BACKEND_IMAGE}
            """
        }

        failure {
            echo """
            ========================================
            BUILD FAILED
            ========================================

            Check the Jenkins console output.
            """
        }

        always {
            sh '''#!/bin/bash
                docker logout || true
            '''

            deleteDir()
        }
    }
}