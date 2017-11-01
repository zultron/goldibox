#!/usr/bin/python
from machinekit import hal
import sys, datetime, yaml, os
persist_fname = "goldibox.conf.yaml"

def infomsg(msg):
    sys.stderr.write("%s Goldibox remote:  %s\n" %
                     (str(datetime.datetime.now()), msg))


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

rcomp.ready()
infomsg("Initialized")

# Restore settings
# - Load pickle file
if os.path.exists(persist_fname):
    with open(persist_fname, 'r') as f:
        data = yaml.load(f)
else:
    data = dict(min_temp=0.0, max_temp=0.0, enable=0)
# - Set controls
rcomp.pin('shutdown').set(0)
for pin, key in (('temp-min', 'temp_min'),
                 ('temp-max', 'temp_max'),
                 ('enable', 'enable')):
    if key in data:
        infomsg("Restoring setting %s = %s" % (pin,data[key]))
        rcomp.pin(pin).set(data[key])

