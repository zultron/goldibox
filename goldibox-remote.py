#!/usr/bin/python
from machinekit import hal

# create remote component
rcomp = hal.RemoteComponent('goldibox-remote', timer=100)


# Controls
rcomp.newpin('enable', hal.HAL_BIT, hal.HAL_OUT)
rcomp.newpin('shutdown', hal.HAL_BIT, hal.HAL_OUT)
rcomp.newpin('temp-max', hal.HAL_FLOAT, hal.HAL_OUT)
rcomp.newpin('temp-min', hal.HAL_FLOAT, hal.HAL_OUT)

# Readouts
rcomp.newpin('error', hal.HAL_BIT, hal.HAL_IN)
rcomp.newpin('p-cool', hal.HAL_BIT, hal.HAL_IN)
rcomp.newpin('p-heat', hal.HAL_BIT, hal.HAL_IN)
rcomp.newpin('switch-on', hal.HAL_BIT, hal.HAL_IN)
rcomp.newpin('temp-int', hal.HAL_FLOAT, hal.HAL_IN)
rcomp.newpin('temp-ext', hal.HAL_FLOAT, hal.HAL_IN)

# Really we need to set everything from a pickle file
# - Controls
rcomp.pin('enable').set(1)
rcomp.pin('shutdown').set(0)
rcomp.pin('temp-max').set(30.0)
rcomp.pin('temp-min').set(15.0)

rcomp.ready()
