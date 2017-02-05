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
            sh 'sudo chown jenkins: "${WORKSPACE:-/var/lib/jenkins/workspace}" -R'
            sh 'rm -rf "$WORKSPACE"/vendor/*'
            sh '"$WORKSPACE"/build/jenkins/get_composer.sh'
            sh 'cd "$WORKSPACE" && ./composer install'
         }

         stage('Code Checks') {

             sh 'cd "$WORKSPACE"'

             parallel (

                 'php-lint': {

                     sh 'sudo docker run -v "`pwd`":"`pwd`" php:7.1-cli /bin/bash -c "find -L `pwd`/src -path */Tests/* -prune -o -name *.php -print0 | xargs -0 -n 1 -P 4 php -l" > $WORKSPACE/build/jenkins/logs/result_phplint71.txt'
                     archiveArtifacts '$WORKSPACE/build/jenkins/logs/result_phplint71.txt'
                 },

                 'php-md': {

                     sh 'sudo docker run -v "`pwd`":"`pwd`" php:7.1-cli /bin/bash -c "php $WORKSPACE/vendor/bin/phpmd src/Symfony/Component/Asset xml codesize --reportfile $WORKSPACE/build/jenkins/logs/result_phpmd.xml --ignore-violations-on-exit"'
                     archiveArtifacts '$WORKSPACE/build/jenkins/logs/result_phpmd.xml'
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