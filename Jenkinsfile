pipeline {

    agent none

    stages {
        stage('Compilation') {
        agent {
                label 'node-master'
            }

            steps {
               sh 'mvn -DskipTests clean install package'
            }
        }

        stage('Unit test') {
        agent {
                label 'node-master'
            }
            steps {
                sh 'mvn test'
            }
            post {
                always {
                   junit 'target/surefire-reports/*.xml'
                }
            }
        }

        stage('Docker - Build Tag y Push') {
        agent {
                label 'node-master'
            }
            steps {
            withCredentials([string(credentialsId: 'docker-id', variable: 'docker-pwd')]) {
                sh 'echo "${docker-pwd}" | docker login --username mmadrigal --password-stdin'
                sh 'mvn compile jib:build'
            }

            }
        }

        stage('Initializing QA') {
            agent {
                    label 'node-qa'
                }
            steps {
                script {
                    def props
                    props = readProperties file: 'versions/version.properties'

                    echo "My tag is ${props['version']}"

                    build job: 'spring-webapp-qa', parameters: [string(name: 'TAG_VERSION', value: "${props['version']}")]
                }
            }
        }

    }
}