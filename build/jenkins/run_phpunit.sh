#!/usr/bin/env bash
#
# execute phpunit without any color output
#

php ./phpunit $@ | perl -pe 's/\e\[?.*?[\@-~]//g'
