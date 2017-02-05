#!/usr/bin/env bash
#
# execute phpunit without any color output
#

cd ../../

echo "--------------"
pwd
echo "--------------"

php phpunit | perl -pe 's/\e\[?.*?[\@-~]//g'