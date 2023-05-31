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
                sh 'docker login --username mmadrigal --password-stdin < ~/docker-pwd.txt'
                sh 'mvn compile jib:build'
            }
        }

        stage('Propagating') {
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