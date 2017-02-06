#!/usr/bin/env bash
#
# execute phpcs with some f*** options and predefined config params
#

PHP_CS_PATH=$1
PHP_CS_REPORT=$2

cd $1 && \
php vendor/bin/phpcs --config-set ignore_errors_on_exit 1 && \
php vendor/bin/phpcs --config-set ignore_warnings_on_exit 1 && \
php vendor/bin/phpcs \
    --encoding=utf-8 \
    --extensions=php \
    --report=checkstyle \
    --no-colors \
    --ignore=*/Tests/*,*/Fixtures/*,*/cache/* \
    --report-file=${PHP_CS_REPORT} \
    ${PHP_CS_PATH}
