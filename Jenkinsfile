#!/usr/bin/env groovy

/**
 * sample pipeline for check/test/run symfony 3.2 CI
 */
 node {

     currentBuild.result = 'SUCCESS'

     try {

         stage('Checkout') {
             checkout changelog: false, poll: false,
             scm:
             [
                 $class: 'GitSCM',
                 branches:
                 [
                     [
                          name: '3.2'
                     ]
                 ],
                 doGenerateSubmoduleConfigurations: false,
                 extensions: [],
                 submoduleCfg: [],
                 userRemoteConfigs:
                 [
                     [
                         url: 'https://github.com/dunkelfrosch/symfony.git'
                     ]
                 ]
             ]
         }

         stage('Code Provision') {

            sh '"$WORKSPACE/build/jenkins/get_composer.sh"'
            sh 'sudo docker run -v "`pwd`":"`pwd`" php:7.1-cli /bin/bash -c "php build/jenkins/composer-setup.php --filename=composer --install-dir=bin"'
            sh 'sudo docker run -v "`pwd`":"`pwd`" php:7.1-cli /bin/bash -c "composer --version"'
         }

         stage('Code Checks') {

             sh 'cd "$WORKSPACE"'

             parallel (

                 'phplint 7.1.n': {

                     sh 'sudo docker run -v "`pwd`":"`pwd`" php:7.1-cli /bin/bash -c "php -v && php -m"'
                     sh 'sudo docker run -v "`pwd`":"`pwd`" php:7.1-cli /bin/bash -c "find -L `pwd`/src -path */Tests/* -prune -o -name *.php -print0 | xargs -0 -n 1 -P 4 php -l" > ./phplint71.txt'
                     archiveArtifacts 'phplint71.txt'
                 },

                 'phplint 7.0.n': {

                     sh 'sudo docker run -v "`pwd`":"`pwd`" php:7.0-cli /bin/bash -c "php -v && php -m"'
                     sh 'sudo docker run -v "`pwd`":"`pwd`" php:7.0-cli /bin/bash -c "find -L `pwd`/src -path */Tests/* -prune -o -name *.php -print0 | xargs -0 -n 1 -P 4 php -l"  > ./phplint70.txt'
                     archiveArtifacts 'phplint70.txt'
                 }
             )
         }

         stage('Cleanup') {

             sh 'cd "$WORKSPACE"'
             sh 'echo -e "cleanUp stuff in $(pwd)"'
         }

     } catch (err) {

         currentBuild.result = "FAILURE"

         throw err
     }
 }