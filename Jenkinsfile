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

                     sh 'cd "$WORKSPACE" && sudo docker run -v "$(pwd)":"$(pwd)" php:7.1-cli /bin/bash -c "find -L $(pwd)/src -path */Tests/* -prune -o -name *.php -print0 | xargs -0 -n 1 -P 4 php -l" > $(pwd)/build/jenkins/logs/result_phplint71.txt'
                     archiveArtifacts 'build/jenkins/logs/result_phplint71.txt'

                 },

                 'php-md': {

                     sh 'cd "$WORKSPACE" && sudo docker run -v "$(pwd)":"$(pwd)" php:7.1-cli /bin/bash -c "php $(pwd)/vendor/bin/phpmd $(pwd)/src/Symfony/Component/Asset xml codesize --reportfile $(pwd)/build/jenkins/logs/result_phpmd.xml --ignore-violations-on-exit"'
                     archiveArtifacts 'build/jenkins/logs/result_phpmd.xml'

                 },

                 'php-cpd': {

                    sh 'cd "$WORKSPACE" && sudo docker run -v "$(pwd)":"$(pwd)" php:7.1-cli /bin/bash -c "php -d memory_limit=512M $(pwd)/vendor/bin/phpcpd $WORKSPACE/src --log-pmd $(pwd)/build/jenkins/logs/result_phpcpd.xml --min-lines=100"'
                    archiveArtifacts 'build/jenkins/logs/result_phpcpd.xml'

                 }
             )
         }

         stage('Code Tests') {

             sh 'cd "$WORKSPACE"'
             sh 'echo -e "running tests in $(pwd)"'
             sh 'sudo docker run -v -t "$(pwd)":"$(pwd)" df/php /bin/bash -c "cd $(pwd) && php phpunit"'
         }

         stage('Cleanup') {

             sh 'echo -e "cleanUp file content in $(pwd)"'
             sh 'rm -rf $WORKSPACE/*'
         }

     } catch (err) {

         currentBuild.result = "FAILURE"

         throw err
     }
 }