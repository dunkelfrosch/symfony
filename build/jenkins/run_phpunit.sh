#!/usr/bin/env bash
#
# execute phpunit without any color output
#

if [ ! -z "$WORKSPACE" ]; then
    echo "_ preparation : using workspace=$WORKSPACE"
    cd $WORKSPACE
else
    echo "_ preparation : workspace not set ... <exit>"
    exit 1
fi

php phpunit | perl -pe 's/\e\[?.*?[\@-~]//g'