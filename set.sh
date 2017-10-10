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
elif test "$1" = siminc; then
    (
	set -x
	halcmd sets outside-temp-incr $2
	halcmd sets heat-cool-incr $3
    )
    exit
elif test "$1" = simset; then
    set -x
    exec halcmd sets outside-temp $2
fi

min=$1
max=$2
hyst=$3

set -x
halcmd sets temp-max $max
halcmd sets temp-min $min
halcmd sets hysteresis $hyst
