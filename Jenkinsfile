pipeline {
  agent {
    kubernetes {
      yamlFile 'build-agent.yaml'
      defaultContainer 'maven'
      idleMinutes 1
    }
  }
  triggers {
    githubPush()
  }
  stages {
    stage('Build') {
      parallel {
        stage('Compile') {
          steps {
            container('maven') {
              sh 'mvn compile'
            }
          }
        }
      }
    }
    stage('Static Analysis') {
      parallel {
        stage('Unit Tests') {
          steps {
            container('maven') {
              sh 'mvn test'
            }
          }
        }
        stage('SCA') {
          steps {
            dependencyCheck additionalArguments: '''
              -o './'
              -s './'
              -f 'ALL'
              --prettyPrint''', odcInstallation: 'OWASP Dependency-Check Vulnerabilities'
            dependencyCheckPublisher pattern: 'dependency-check-report.xml'
          }
        }
      }
    }
    stage('Package') {
      parallel {
        stage('Create Jarfile') {
          steps {
            container('maven') {
              sh 'mvn package -DskipTests'
            }
          }
        }
/*        stage('Docker BnP') {
          steps {
            container('buildkitd') {
              sh 'buildctl build --frontend dockerfile.v0 --local context=. --local dockerfile=. --output type=image,name=docker.io/gchangdckr/dsodemo:tag1,push=true'
            }
          }
        }
      }
    }
*/
    stage('Deploy to Dev') {
      steps {
        // TODO
        sh "echo done"
      }
    }
  }
}
