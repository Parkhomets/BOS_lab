#!/bin/bash

CONF=/opt/checker/checker.conf
timeout=60
TEST_FILE=checker_test_file_example

function TEST {
    echo -n $1 "     "
    if [[ $2 != $3 ]]
    then
        echo "FAIL"
        echo "expected:    " $3
        echo "     got:    " $2
    else
        echo "OK"
    fi
}

echo "$TEST_FILE:111:root:root" >> $CONF
touch $TEST_FILE



#  start  test
chmod 777 $TEST_FILE
./checker.sh &
CHECKER_PID=$!
sleep 1
realPerm=$( find $TEST_FILE -printf '%m' )
TEST "start test: " $realPerm "111"


# SIG1 test
chmod 777 $TEST_FILE
kill -USR1 $CHECKER_PID
sleep 1
realPerm=$( find $TEST_FILE -printf '%m' )
TEST "signal test: " $realPerm "111"


# change test
chmod 777 $TEST_FILE
echo "wait timeout: " $timeout " second"
sleep $timeout
realPerm=$( find $TEST_FILE -printf '%m' )
TEST "timeout test: " $realPerm "111"



rm $TEST_FILE
sed -i '$d' $CONF
