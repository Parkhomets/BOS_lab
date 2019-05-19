#!/bin/bash

CONF=/opt/checker/checker.conf
IFS=":"
timeout=60
pidFile=/opt/checker/checker.pid

echo $$ > $pidFile

function Log {
	systemd-cat echo $1
    }

function checkPaermission {
    realPerm=$( find $FILE -printf '%m' )
    if [[ $realPerm != $REST ]]
    then
        Log "CHECKER ERROR: Expected $REST Got $realPerm for $FILE"
        chmod $REST $FILE
    fi
}

function checkUser {
	user=$( find $FILE -printf '%u\n' )
	if [ "$user" != "$USER"  ]
	then
	 Log "CHECKER ERROR: Expected $USER Got $user for $FILE"
	 chown $USER $FILE
	fi
}

function checkGroup {
	group=$( find $FILE -printf '%g\n' )
	if [ "$group" != "$GROUP" ]
	then
	 chgrp $GROUP $FILE
	 Log "CHECKER ERROR: Expected $GROUP Got $group for $FILE"
	fi
}

function MainCheck {
    Log "CHECKER: Scanning is beginning"
    while read FILE REST USER GROUP
    do
        checkPaermission $FILE $REST
        checkUser $FILE $USER
	checkGroup $FILE $GROUP
    done < $CONF
    Log "CHECKER: Scanning is successfully complited"
    # Log "PID=$$"
}

function CheckBySignal {
    Log "SIGUSR1"
    MainCheck
}

function onexit {
    Log "Exit"
}

trap "CheckBySignal" SIGUSR1
trap "onexit" EXIT

while true
do
    Log "Start service"
    wait && MainCheck
    sleep $timeout &
done

