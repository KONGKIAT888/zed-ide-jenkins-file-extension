// Example declarative Jenkins Pipeline.
// Open this file in Zed to try out the Jenkinsfile extension:
// syntax highlighting, `sh` step bash injection, stage outline, brackets.

pipeline {
    agent any

    options {
        timestamps()
        disableConcurrentBuilds()
        buildDiscarder(logRotator(numToKeepStr: '10'))
        timeout(time: 30, unit: 'MINUTES')
    }

    triggers {
        cron('H/15 * * * *')
    }

    parameters {
        string(name: 'DEPLOY_ENV', defaultValue: 'staging', description: 'Target environment')
        choice(name: 'REGION', choices: ['us-east-1', 'eu-west-1'], description: 'AWS region')
        booleanParam(name: 'RUN_TESTS', defaultValue: true, description: 'Run the test suite')
    }

    environment {
        APP_NAME = 'demo-service'
        VERSION = "${env.BUILD_NUMBER}-${env.GIT_COMMIT.take(7)}"
    }

    tools {
        nodejs 'node-20'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build') {
            steps {
                sh 'npm ci'
                sh """
                    npm run build -- --env=${params.DEPLOY_ENV}
                """
            }
        }

        stage('Test') {
            when {
                expression { params.RUN_TESTS }
            }
            steps {
                sh 'npm test -- --region=${params.REGION}'
            }
            post {
                always {
                    junit 'test-results/*.xml'
                }
            }
        }

        stage('Deploy') {
            when {
                anyOf {
                    branch 'main'
                    tag pattern: "v\\d+\\.\\d+\\.\\d+", comparator: 'REGEXP'
                }
            }
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: 'deploy-key', keyFileVariable: 'KEYFILE')]) {
                    sh './scripts/deploy.sh'
                }
            }
        }
    }

    post {
        success {
            echo "Build ${env.BUILD_NUMBER} succeeded"
        }
        failure {
            slackSend channel: '#ci', message: "Build failed: ${env.JOB_NAME} #${env.BUILD_NUMBER}"
        }
        always {
            cleanWs()
        }
    }
}
