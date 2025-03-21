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

## PATHs
PROFILE_HOME=$SAG_HOME/DeveloperPortal
WRAPPER_CONFIGS_DIR=$PROFILE_HOME/configuration
WRAPPER_OPTIONS_FILE=$WRAPPER_CONFIGS_DIR/wrapper.conf
WRAPPER_CUSTOM_OPTIONS_FILE=$WRAPPER_CONFIGS_DIR/custom_wrapper.conf

function stop_server() {
   echo "Info:Shutting the devportal server process"   
   cd ${PROFILE_HOME}/bin && /bin/sh shutdown.sh
   exit 0
}

## set JVM settings
logger $LOGGER_INFO "Setting up wrapper JVM settings"

## add an extra line in the custom_wrapper file to avoid line issues with the additions below
echo "" >> $WRAPPER_CUSTOM_OPTIONS_FILE

## testing
comment_line_in_file "wrapper.java.additional.2005" $WRAPPER_CUSTOM_OPTIONS_FILE

# define a stable index to start from
jvm_index_start=500

# set the value of HEAP_SIZE as passed in via environment variable.
if [ "x$JAVA_MIN_MEM" != "x" ]; then
    logger $LOGGER_INFO "Env var JAVA_MIN_MEM set to $JAVA_MIN_MEM - Will set it up"
    jvm_min_mem_index=$((jvm_index_start + 0))
    logger $LOGGER_INFO "Apply new JVM wrapper property wrapper.java.additional.${jvm_min_mem_index}"

    comment_line_in_file "wrapper.java.initmemory" $WRAPPER_OPTIONS_FILE
    comment_line_in_file "wrapper.java.initmemory" $WRAPPER_CUSTOM_OPTIONS_FILE
    replace_or_add_line "wrapper.java.additional.${jvm_min_mem_index}" "wrapper.java.additional.${jvm_min_mem_index}=-Xms${JAVA_MIN_MEM}" $WRAPPER_CUSTOM_OPTIONS_FILE
fi

if [ "x$JAVA_MAX_MEM" != "x" ]; then
    logger $LOGGER_INFO "Env var JAVA_MAX_MEM set to $JAVA_MAX_MEM - Will set it up"
    jvm_max_mem_index=$((jvm_index_start + 1))
    logger $LOGGER_INFO "Apply new JVM wrapper property wrapper.java.additional.${jvm_max_mem_index}"

    comment_line_in_file "wrapper.java.maxmemory" $WRAPPER_OPTIONS_FILE
    comment_line_in_file "wrapper.java.maxmemory" $WRAPPER_CUSTOM_OPTIONS_FILE
    replace_or_add_line "wrapper.java.additional.${jvm_max_mem_index}" "wrapper.java.additional.${jvm_max_mem_index}=-Xmx${JAVA_MAX_MEM}" $WRAPPER_CUSTOM_OPTIONS_FILE
fi

# customize load balancer url for UMC
if [ "x$PORTAL_SERVER_UMC_LB_URL" != "x" ]; then
    logger $LOGGER_INFO "Env var PORTAL_SERVER_UMC_LB_URL set to $PORTAL_SERVER_UMC_LB_URL - Will set it up"

    umclburl_start_index=$((jvm_index_start + 2))
    replace_or_add_line "wrapper.java.additional.${umclburl_start_index}" "wrapper.java.additional.${umclburl_start_index}=-Dcom.softwareag.portal.umc.loadbalancer.url=$PORTAL_SERVER_UMC_LB_URL" $WRAPPER_CUSTOM_OPTIONS_FILE
fi

# customize java opts
if [ "x$JAVA_OPTS" != "x" ]; then
    logger $LOGGER_INFO "Env var JAVA_OPTS set to $JAVA_OPTS - Will set it up"
    javaopts_array=($JAVA_OPTS)
    javaopts_start_index=$((jvm_index_start + 3))
    for index in "${!javaopts_array[@]}"; do
        javaopts_index=$((javaopts_start_index + $index))
        logger $LOGGER_INFO "Apply new JVM wrapper property wrapper.java.additional.${javaopts_index}=${javaopts_array[index]}"
        replace_or_add_line "wrapper.java.additional.${javaopts_index}" "wrapper.java.additional.${javaopts_index}=${javaopts_array[index]}" $WRAPPER_CUSTOM_OPTIONS_FILE
    done
fi

## list of space separated path to cert files (pem)
if [ "x$CUSTOM_TRUST_CERTS" != "x" ]; then
    logger $LOGGER_INFO "Env var CUSTOM_CERT_TRUSTS set to $CUSTOM_TRUST_CERTS - Will set it up"
    certs_array=($CUSTOM_TRUST_CERTS)
    for certitem in "${certs_array[@]}"; do
        certpath="${certitem%%=*}"
        certalias="${certitem#*=}"
        logger $LOGGER_DEBUG "Cert/Alias pair [${certpath}]=${certalias}"

        if [ ! -f $certpath ]; then
            logger $LOGGER_WARN "Cert path [$certpath] does not exist on the file system...ignoring this cert entry!"
        else
            if [ "x$certalias" != "x" ]; then
                logger $LOGGER_INFO "Adding the cert/alias pair ${certpath}=${certalias} into the JVM $JAVA_HOME/lib/security/cacerts"
                $JAVA_HOME/bin/keytool -import -noprompt -trustcacerts -cacerts -storepass changeit -alias $certalias -file $certpath
            else
                logger $LOGGER_WARN "certalias is empty...ignoring this cert/alias entry!"
            fi
        fi
    done
else
    logger $LOGGER_WARN "CUSTOM_TRUST_CERTS is empty...will not setup any custom cert into the JAVA cacerts store."
fi

trap stop_server SIGTERM

#start container
logger $LOGGER_INFO "Start container with expected process..."
/usr/local/bin/supervisord
tail -f ${PROFILE_HOME}/logs/wrapper.log