pipeline {
    agent any
    stages{
        stage ('Build Backend') {
            steps {
                sh 'mvn clean package -DskipTest'
            }
        }
        stage ('Unit Tests') {
            steps {
                sh 'mvn test'
            }
        }
    }
}