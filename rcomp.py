#!/usr/bin/python
from machinekit import hal
from pprint import pprint

# create remote component
rcomp = hal.RemoteComponent('remote', timer=100)

# Controls
rcomp.newpin('enable', hal.HAL_BIT, hal.HAL_OUT)
rcomp.newpin('shutdown', hal.HAL_BIT, hal.HAL_OUT)
rcomp.newpin('temp-max', hal.HAL_FLOAT, hal.HAL_OUT)
rcomp.newpin('temp-min', hal.HAL_FLOAT, hal.HAL_OUT)
rcomp.newpin('hysteresis', hal.HAL_FLOAT, hal.HAL_OUT)

# Readouts
rcomp.newpin('error', hal.HAL_BIT, hal.HAL_IN)
rcomp.newpin('p-neg', hal.HAL_BIT, hal.HAL_IN)
rcomp.newpin('p-pos', hal.HAL_BIT, hal.HAL_IN)
rcomp.newpin('switch-heat', hal.HAL_BIT, hal.HAL_IN)
rcomp.newpin('switch-on', hal.HAL_BIT, hal.HAL_IN)
rcomp.newpin('temp-int', hal.HAL_FLOAT, hal.HAL_IN)

# Controls-sim
rcomp.newpin('outside-temp', hal.HAL_FLOAT, hal.HAL_OUT)
rcomp.newpin('outside-temp-incr', hal.HAL_FLOAT, hal.HAL_OUT)
rcomp.newpin('heat-cool-incr', hal.HAL_FLOAT, hal.HAL_OUT)

# Readouts-sim
rcomp.newpin('sim-error', hal.HAL_BIT, hal.HAL_IN)

# Really we need to set everything from a pickle file
# - Controls
rcomp.pin('enable').set(1)
rcomp.pin('shutdown').set(0)
rcomp.pin('temp-max').set(30.0)
rcomp.pin('temp-min').set(15.0)
rcomp.pin('hysteresis').set(2.0)
# - Controls-sim
rcomp.pin('outside-temp').set(20.0)
rcomp.pin('outside-temp-incr').set(0.01)
rcomp.pin('heat-cool-incr').set(0.02)

rcomp.ready()

# start haltalk server after everything is initialized
# else binding the remote components on the UI might fail
hal.loadusr('haltalk')

import time
while True:
    time.sleep(100)

    # Really we need to watch for changes and persist


# Really we need to persist current settings
