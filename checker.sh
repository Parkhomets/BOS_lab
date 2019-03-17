#!/bin/bash

CONF=config.conf
IFS=":"
timeout=5
logFile="lab.log"


function Log {
    eventTime=$( date )
    echo "[" $eventTime "] " $1 # >> logFile
}

function checkPaermission {
    realPerm=$( find $FILE -printf '%m' )
    if [[ $realPerm != $REST ]]
    then
        Log "ERROR: Expected $REST Got $realPerm for $FILE"
        chmod $REST $FILE
    fi
}

function MainCheck {
    Log "begin scan"
    while read FILE REST USER GROUP
    do
        checkPaermission $FILE $REST
        #
        # TODO: add other checks
        #
    done < $CONF
    Log "scan finished"
    # Log "PID=$$"
}

function CheckBySignal {
    Log "SIGUSR1"
    MainCheck
}

trap "CheckBySignal" SIGUSR1

while true
do
    wait && MainCheck
    sleep $timeout &
done

