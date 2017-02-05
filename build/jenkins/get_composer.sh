#!/usr/bin/env bash
#
# fetch the latest composer version using bash
#

COMPOSER_FILE="./composer"
COMPOSER_SETUP_FILE="/tmp/composer-setup.php"

if [ ! -z "$WORKSPACE" ]; then
    echo "_ preparation : using workspace=$WORKSPACE"
    else
    echo "_ preparation : workspace not set"
fi

echo -e "_ preparation : ---- get composer installer from origin source(s)"
if wget -q "https://getcomposer.org/installer" -O "${COMPOSER_SETUP_FILE}"; then
    echo -e "_ preparation : [OK] composer downloaded successfully"
else
    echo -e "_ preparation : [FAIL] composer couldn't downloaded, operation ends here ..."
    exit 1
fi

SIGNATURE_EXPECTED=`wget -q -O - https://composer.github.io/installer.sig`
SIGNATURE_CURRENT=`sha384sum ${COMPOSER_SETUP_FILE} | cut -d' ' -f1`

echo -e "_ preparation : ---- validate composer sha384 signature"
if [ "${SIGNATURE_EXPECTED}" != "${SIGNATURE_CURRENT}" ]
then
    >&2 echo -e "_ preparation : [FAIL] Invalid installer signature, composer installation aborted"
    rm -f ${COMPOSER_SETUP_FILE};
    exit 2
else
    echo -e "_ preparation : [OK] signature is valid"
fi

echo -e "_ preparation : ---- install composer binary"
php "${COMPOSER_SETUP_FILE} --filename=${COMPOSER_FILE} --install-dir=${WORKSPACE}"
