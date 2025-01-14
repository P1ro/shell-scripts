#! /usr/bin/env bash
#
# Simple bash script wrapper around perl.
#
# Note:
# - used to work around problem passing environment variables on command line.
#   For example,
#      alias ps-sort-debug='DEBUG_LEVEL=5 perl.sh -Ssw ps_sort.perl'
# - This is in support of DURING_ALIAS using in tomohara-aliases.bash.
# - See common.perl for the usage (e.g., init_common).
#

## DEBUG:
## echo "DEBUG_LEVEL=$DEBUG_LEVEL"
## echo "DURING_ALIAS=$DURING_ALIAS"

perl "$@"
