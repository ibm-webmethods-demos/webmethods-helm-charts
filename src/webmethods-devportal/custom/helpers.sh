#!/bin/sh

# logger levels to be used in code
LOGGER_TRACE=0
LOGGER_DEBUG=1
LOGGER_INFO=2
LOGGER_WARN=3
LOGGER_ERROR=4

# if main debug levelk not defined, default to LOGGER_ERROR
if [ "x$SCRIPTS_LOGGER_LEVEL" == "x" ]; then
    SCRIPTS_LOGGER_LEVEL=$LOGGER_INFO
fi

# logger function
function logger() {
    local level=$1;
    local message=$2;
    if [[ $level -ge $SCRIPTS_LOGGER_LEVEL ]]; then
        echo "[ $level ] - MSG: ${message}"
    fi
}
function replace_or_add_line { 
    local pattern=$1;
    local replacement=$2;
    local file=$3;

    logger $LOGGER_DEBUG "Begin replace_or_add_line[pattern=$pattern,replacement=$replacement,file=$file]"

    #note: to avoid invalid matcher error if pattern starts with -, use -- to tell grep to stop processing command line arguments
    test_pattern_exists=`grep -- "$pattern" $file | tail -n1`
    if [ "x$test_pattern_exists" == "x" ]; then
        logger $LOGGER_DEBUG "pattern does not exist in file, will simply append the value $replacement to file"
        echo $replacement >> $file
    else
        logger $LOGGER_DEBUG "pattern exists in file, will replace existing with replacement value $replacement"
        replace_line "$pattern" "$replacement" "$file"
    fi
}
function get_highest_wrapper_java_additional_index() {
    local filename=$1
    local highest_wrapper_java_additional_index=0
    while read line
    do
    if [[ $line == *"wrapper.java.additional."* ]]; then
        #get all the digits from line and extract 1st set of digits
        digits=( $(echo $line | grep -o -E '[0-9]+') )
        index=${digits[0]}
        if [ ! -z $index ] && [ $index -gt $highest_wrapper_java_additional_index ]; then
        highest_wrapper_java_additional_index=$index
        fi
    fi
    done < $filename
    echo $highest_wrapper_java_additional_index
}