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
        stage ('Sonar Analysis') {
            steps {
                enviroment {
                    scannerHome = tool 'SONAR_SCANNER'
                }
                withSonarQubeEnv('Sonar_local'){
                    sh "${scannerHome}/bin/sonar-scanner -e -Dsonar.projectKey=Deployback -Dsonar.projectName='Deployback' -Dsonar.host.url=http://193.123.103.197:9000 -Dsonar.token=sqp_47e5c7c343659ea6d1895081c1e81b158306f09a -Dsonar.java.binaries=target"
                }
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
        stage ('Deploy Front') {
            steps {
                dir('frontend') {
                    git branch: 'master', url: 'https://github.com/gabslin/tasks-frontend.git'
                    sh 'mvn clean package'
                    deploy adapters: [tomcat8(credentialsId: '68e0d715-c962-4b1c-a519-904fc6d5d767', path: '', url: 'http://193.123.103.197:8001')], contextPath: 'tasks', war: 'target/tasks.war'
                }
            }
        }
        stage ('Test Funcional') {
            steps {
                dir('test-funcional') {
                    git branch: 'main', url: 'https://github.com/gabslin/tasks-funcional-test.git'
                    sh 'mvn test'
                }
            }
        }
        stage ('Deploy Prod') {
            steps {
                sh 'docker compose build' 
                sh 'docker compose up -d'
            }
        }
        stage ('Health check') {
            steps {
                sleep(30)
                dir('test-funcional') {
                    sh "mvn verify '-Dskip.surefire.tests'"
                }
            }
        }
    }
    post {
        always{
            junit allowEmptyResults: true, testResults: 'target/surefire-reports/*.xml, test-funcional/target/surefire-reports/*.xml, test-funcional/target/failsafe-reports/*.xml'
            archiveArtifacts artifacts: 'target/tasks-backend.war, Frontend/target/tasks.war', followSymlinks: false, onlyIfSuccessful: true
        }
    }
}