#!/usr/bin/env groovy

import hudson.model.*

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
            sh 'sudo docker run -t -v "$(pwd)":"$(pwd)" df/php:latest /bin/bash -c "cd $(pwd) && composer install --no-ansi --no-interaction"'
         }

         stage('Code Checks') {

             sh 'cd "${WORKSPACE}"'

             parallel (

                 'php-lint': {

                     sh 'cd "${WORKSPACE}" && sudo docker run -v "$(pwd)":"$(pwd)" jenkins/df/alpine/stack/php:7.1.1 /bin/bash -c "find -L ${WORKSPACE}/src -path */Tests/* -prune -o -name *.php -print0 | xargs -0 -n 1 -P 4 php -l" > ${WORKSPACE}/build/jenkins/logs/result_phplint71.txt'
                     archiveArtifacts 'build/jenkins/logs/result_phplint71.txt'

                 },

                 'php-md': {

                     sh 'cd "${WORKSPACE}" && sudo docker run -v "$(pwd)":"$(pwd)" jenkins/df/alpine/stack/php:7.1.1 /bin/bash -c "php -d memory_limit=512M ${WORKSPACE}/vendor/bin/phpmd ${WORKSPACE}/src/Symfony/Component/Asset xml codesize --reportfile ${WORKSPACE}/build/jenkins/logs/result_phpmd.xml --ignore-violations-on-exit --suffixes php"'
                     archiveArtifacts 'build/jenkins/logs/result_phpmd.xml'

                 },

                 'php-cpd': {

                    sh 'cd "${WORKSPACE}" && sudo docker run -v "$(pwd)":"$(pwd)" jenkins/df/alpine/stack/php:7.1.1 /bin/bash -c "php -d memory_limit=512M ${WORKSPACE}/vendor/bin/phpcpd ${WORKSPACE}/src --log-pmd ${WORKSPACE}/build/jenkins/logs/result_phpcpd.xml --min-lines=100"'
                    archiveArtifacts 'build/jenkins/logs/result_phpcpd.xml'

                 },

                 'php-cs': {

                    sh 'cd "${WORKSPACE}" && sudo docker run -t -v "$(pwd)":"$(pwd)" jenkins/df/alpine/stack/php:7.1.1 /bin/bash -c "${WORKSPACE}/build/jenkins/run_phpcs.sh ${WORKSPACE} ${WORKSPACE}/src ${WORKSPACE}/build/jenkins/logs/result_phpcs.xml"'
                    archiveArtifacts 'build/jenkins/logs/result_phpcs.xml'

                 }
             )
         }

         stage('Code Tests') {

             sh 'cd "${WORKSPACE}" && sudo docker run -t -v "$(pwd)":"$(pwd)" jenkins/df/alpine/stack/php:7.1.1 /bin/bash -c "${WORKSPACE}/build/jenkins/run_phpunit.sh ${WORKSPACE}"'

         }

         stage('Cleanup') {

             sh 'sudo rm -rf ${WORKSPACE}/*'
         }

     } catch (err) {

         currentBuild.result = "FAILURE"

         throw err
     }
 }