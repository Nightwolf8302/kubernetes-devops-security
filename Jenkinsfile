pipeline {
  agent any

  stages {

    stage('Build Artifact - Maven') {
      steps {
        sh "mvn clean package -DskipTests=true"
        archive 'target/*.jar'
      }
    }



    stage('Unit Tests - JUnit and Jacoco') {
      steps {
        sh "mvn test"
      }
      post {
        always {
          junit 'target/surefire-reports/*.xml'
          jacoco execPattern: 'target/jacoco.exec'
        }
      }
    }
      stage('Mutation Tests - PIT') {
      steps {
        sh "mvn org.pitest:pitest-maven:mutationCoverage"
      }
      post {
        always {
          pitmutation mutationStatsFile: '**/target/pit-reports/**/mutations.xml'
        }
      }
    }

 }
  stage('SonarQube - SAST') {
      steps {
sh "mvn sonar:sonar  -Dsonar.projectKey=test  -Dsonar.host.url=http://nightwolf.centralus.cloudapp.azure.com:9000 -Dsonar.login=99de2738accd3c40a0e5e3ac6b2da7e7fc2c6a44"
  }
      }

    stage('Docker Build and Push') {
      steps {
       withDockerRegistry([credentialsId: "dockerhub", url: ""]) {
          sh 'printenv'
          sh 'docker build -t domdockid/test-app:""$GIT_COMMIT"" .'
          sh 'docker push domdockid/test-app:""$GIT_COMMIT""'
        }
      }
    }

stage('Kubernetes Deployment - DEV') {
      steps {
        withKubeConfig([credentialsId: 'kubeconfig']) {
          sh "sed -i 's#replace#domdockid/test-app:${GIT_COMMIT}#g' k8s_deployment_service.yaml"
          sh "kubectl apply -f k8s_deployment_service.yaml"
        }
      }
    }
    
  }

}
 
