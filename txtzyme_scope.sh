#!/bin/bash 
#
# The Artistic License 2.0
# Copyright (c) 2014 SeungBum Kim <picxenk@gmail.com>
# license details at : http://choosealicense.com/licenses/artistic/
#
# Plotting signals on terminal with Txtzyme
# reference : http://dorkbotpdx.org/blog/wardcunningham/plotting_signals_with_txtzyme

if [ -z "$1" ]; then
    echo "[USAGE] $0 SERIAL_PORT [INPUT_PIN:default=5s]"
    exit
fi
TEENSY=$1;
INPUT_PIN=$2;
if [ -z "$2"]; then
    INPUT_PIN='5s'
fi


# set trap to kill perl process
function kill_perl {
    PID=`ps -ax | grep '[0-9] perl' | awk '{print $1}' | head -n 1`
    echo "Kill perl process: $PID"
    kill $PID
    exit
}
trap kill_perl SIGHUP SIGINT SIGTERM


# terminal plotting from teensy input
perl -pe 's/(\d+)/$1."\t"."|"x($1*.1)/e' < $TEENSY &


# get value from teensy 
while 
    sleep .12; 
    do clear; 
    echo "50 { $INPUT_PIN p }" > $TEENSY;
done
