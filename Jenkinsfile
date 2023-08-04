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
        stage ('Deploy Back') {
            steps {
                deploy adapters: [tomcat8(credentialsId: '68e0d715-c962-4b1c-a519-904fc6d5d767', path: '', url: 'http://193.123.103.197:8001')], contextPath: 'tasks-backend', war: 'target/tasks-backend.war'
            }
        }
        stage ('API Test') {
            steps {
                dir('api-test') {
                    git branch: 'main', url: 'https://github.com/gabslin/tasks-api-test'
                    sh 'mvn test'
                }
            }
        }
        stage ('Deploy Back') {
            steps {
                dir('Frontend') {
                    git branch: 'master', url: 'https://github.com/gabslin/tasks-frontend.git'
                    sh 'vn clean package'
                    deploy adapters: [tomcat8(credentialsId: '68e0d715-c962-4b1c-a519-904fc6d5d767', path: '', url: 'http://193.123.103.197:8001')], contextPath: 'tasks', war: 'target/tasks.war'
                }
            }
        }
    }
}