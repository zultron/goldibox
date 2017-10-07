#!/bin/bash -e

if test "$1" = shutdown; then
    set -x
    exec halcmd sets shutdown 1
elif test "$1" = disable; then
    set -x
    exec halcmd sets enable 0
elif test "$1" = enable; then
    set -x
    exec halcmd sets enable 1
fi

min=$1
max=$2
hyst=$3

set -x
halcmd sets temp-max $max
halcmd sets temp-min $min
halcmd sets hysteresis $hyst
