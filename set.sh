#!/bin/bash -e

if test "$1" = shutdown; then
    set -x
    exec halcmd sets shutdown 1
fi

min=$1
max=$2
hyst=$3

set -x
halcmd sets temp-max $max
halcmd sets temp-min $min
halcmd sets hysteresis $hyst
