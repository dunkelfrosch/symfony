#!/usr/bin/env bash
#
# execute phpunit without any color output
#

cd $1 && \
php ./phpunit | perl -pe 's/\e\[?.*?[\@-~]//g'
