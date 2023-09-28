#!/bin/sh
set -e

## current dir
THISDIR=$(dirname $0)
THISDIR=$(
    cd $THISDIR
    pwd
)

## set var if containers uses the wrapper to start
SAG_CONTAINER_START_USE_WRAPPER=yes

## load utils functions
. $THISDIR/helpers.sh

logger $LOGGER_INFO "Begin Custom APIGW entrypoint..."

# instance name
if [ "x$INSTANCE_NAME" == "x" ]; then
    logger $LOGGER_ERROR "INSTANCE_NAME env is not set"
    exit 2;
fi

## PATHs
PROFILE_HOME=$SAG_HOME/profiles/IS_$INSTANCE_NAME
RUNTIME_IS_HOME=$SAG_HOME/IntegrationServer
RUNTIME_IS_INSTANCE_HOME=$RUNTIME_IS_HOME/instances/$INSTANCE_NAME
RUNTIME_IS_CONFIG_FILE=$RUNTIME_IS_INSTANCE_HOME/config/server.cnf
WRAPPER_CONFIGS_DIR=$PROFILE_HOME/configuration
WRAPPER_OPTIONS_FILE=$WRAPPER_CONFIGS_DIR/wrapper.conf
WRAPPER_CUSTOM_OPTIONS_FILE=$WRAPPER_CONFIGS_DIR/custom_wrapper.conf

# define a stable index to start from
highest_wrapper_java_additional_index=$(get_highest_wrapper_java_additional_index "$WRAPPER_CUSTOM_OPTIONS_FILE")
((jvm_index_start=$highest_wrapper_java_additional_index+100))

## set JVM settings
if [ "$SAG_CONTAINER_START_USE_WRAPPER" == "yes" ]; then
    logger $LOGGER_INFO "Process will use wrapper - setting up wrapper JVM settings"

    if [ "x$JAVA_OPTS" != "x" ]; then
        logger $LOGGER_INFO "Env var JAVA_OPTS set to $JAVA_OPTS - Will set it up"
        javaopts_array=($JAVA_OPTS)
        javaopts_start_index=$((jvm_index_start + 2))
        for index in "${!javaopts_array[@]}"; do
            javaopts_index=$((javaopts_start_index + $index))
            logger $LOGGER_INFO "Apply new JVM wrapper property wrapper.java.additional.${javaopts_index}=${javaopts_array[index]}"

            replace_or_add_line "wrapper.java.additional.${javaopts_index}" "wrapper.java.additional.${javaopts_index}=${javaopts_array[index]}" $WRAPPER_CUSTOM_OPTIONS_FILE
        done
    fi
fi

#start container
exec ${RUNTIME_IS_HOME}/bin/startContainer.sh