#!/usr/bin/env bash
#
# execute phpunit without any color output
#

cd ../../

php phpunit | perl -pe 's/\e\[?.*?[\@-~]//g'