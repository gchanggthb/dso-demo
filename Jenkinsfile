pipeline {
  agent {
    kubernetes {
      yamlFile 'build-agent.yaml'
      defaultContainer 'maven'
      idleMinutes 1
    }
  }
  environment {
    DOCKERHUB_CRED = credentials('dockercred')
    REPO = "gchangdckr/dsodemo"
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
              sh 'pwd'
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
//              sh 'mvn test'
            }
          }
        }
        stage('SCA') {
          steps {
            container('maven') {
              sh 'pwd'
              catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
//                sh 'mvn org.owasp:dependency-check-maven:check'
              }
            }
          }
          post {
            always {
              archiveArtifacts allowEmptyArchive: true, artifacts: 'target/dependency-check-report.html', fingerprint: true, onlyIfSuccessful: true
            }
          }
        }
        stage('OSS License Checker') {
          steps {
            container('licensefinder') {
              sh 'ls -al'
  /*            sh '''#!/bin/bash --login
                      /bin/bash --login
                      rvm use default
                      gem install license_finder
                      license_finder
                 '''
    */        }
          }
        }
      }
    }
    stage('SAST') {
      steps {
        container('slscan') {
  //        sh 'scan --type java,depscan --build'
        }
      }
      post {
        success {
          archiveArtifacts allowEmptyArchive: true,
          artifacts: 'reports/*', fingerprint: true, onlyIfSuccessful: true

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
        stage('Docker BnP') {
          steps {
            container('buildkitd') {
//              sh 'buildctl build --frontend dockerfile.v0 --local context=. --local dockerfile=. --output type=image,name=docker.io/gchangdckr/dsodemo:v5,push=true'
            }
          }
        }
      }
    }
    stage('Image Analysis') {
      parallel {
        stage('Image Linting') {
          steps {
            container('docker-tools') {
              //sh 'dockle docker.io/gchangdckr/dsodemo'
/*              sh '''#!/bin/bash
                  export DOCKLE_AUTH_URL=https://registry.hub.docker.com
                  export DOCKLE_USERNAME=$DOCKERHUB_CRED_USR
                  echo $DOCKLE_USERNAME
                  export DOCKLE_PASSWORD=$DOCKERHUB_CRED_PSW
                  echo $DOCKLE_PASSWORD
                  dockle --authurl https://registry.hub.docker.com --username $DOCKERHUB_CRED_USR --password $DOCKERHUB_CRED_PSW docker.io/gchangdckr/dsodemo:v5
                 '''
*/
              sh 'echo $DOCKERHUB_CRED_PSW > tmp2'
              print 'pass2 '
              sh 'cat tmp2'

              script {
                String pass
                withCredentials([
                  usernamePassword(credentialsId: 'dockercred', usernameVariable: 'usr', passwordVariable: 'psw')
                ]) {
                  print 'username ' + usr
                  print 'password ' + psw
              //    pass = psw
              //    sh 'dockle --authurl https://registry.hub.docker.com --username $usr --password $psw docker.io/gchangdckr/dsodemo:v5'
              //    sh 'docker login -u $usr -p "$psw"'
              //    sh 'docker logout'
              //    print 'pass '
              //    echo  $pass > tmp && cat tmp
                }
                //print 'password2 ' + pass
              }
            }
          }
        }
        stage('Image Scan') {
          steps {
            container('docker-tools') {
              //sh 'export TRIVY_AUTH_URL='
              //sh 'export TRIVY_PASSWORD=$DOCKERHUB_CRED_USR'
              //sh 'export TRIVY_USERNAME=$DOCKERHUB_CRED_PSW'
    /*          sh '''#!/bin/bash
                  export DOCKLE_AUTH_URL=https://registry.hub.docker.com
                  export DOCKLE_USERNAME=$DOCKERHUB_CRED_USR
                  echo $DOCKLE_USERNAME
                  export DOCKLE_PASSWORD=$DOCKERHUB_CRED_PSW
                  echo $DOCKLE_PASSWORD
                  trivy image --exit-code 1 $REPO:v5
                 '''
      */      }
          }
        }
      }
    }

    stage('Deploy to Dev') {
      steps {
        // TODO
        sh "echo done"
      }
    }
  }
}
