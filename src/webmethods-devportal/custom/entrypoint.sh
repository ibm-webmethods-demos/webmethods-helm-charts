#!/bin/sh
set -e

## current dir
THISDIR=$(dirname $0)
THISDIR=$(
    cd $THISDIR
    pwd
)

## load utils functions
. $THISDIR/helpers.sh

logger $LOGGER_INFO "Begin Custom Devportal entrypoint..."

#start container
logger $LOGGER_INFO "Start container with expected process..."
/bin/sh -c /usr/local/bin/supervisord