#!/usr/bin/python

import hal, time, sys, datetime, yaml, os
from machinekit import hal as mk_hal
persist_fname = "goldibox.conf.yaml"

def infomsg(msg):
    sys.stderr.write("%s Goldibox settings:  %s\n" %
                     (str(datetime.datetime.now()), msg))

# Set up component
h = hal.component("goldibox-settings")

# Inputs:
# - Min/max temp settings
h.newpin("temp-min", hal.HAL_FLOAT, hal.HAL_IN)
h.newpin("temp-max", hal.HAL_FLOAT, hal.HAL_IN)
# - Shutdown pin
h.newpin("shutdown", hal.HAL_BIT, hal.HAL_IN)

# Mark the component as 'ready'
infomsg("Initialized")
h.ready()

# Load settings
if os.path.exists(persist_fname):
    with open(persist_fname, 'r') as f:
        data = yaml.load(f)
else:
    data = dict(min_temp=0.0, max_temp=0.0)
for signame, key in (('temp-min', 'temp_min'), ('temp-max', 'temp_max')):
    if signame in mk_hal.signals:
        sig = mk_hal.signals[signame]
    else:
        sig = mk_hal.newsig(signame, hal.HAL_FLOAT)
    sig.set(data[key])

while True:
    time.sleep(0.1)
    if h['shutdown']:
        infomsg("Saving settings")
        with open(persist_fname, 'w') as f:
            yaml.dump(
                dict(temp_min = h['temp-min'],
                     temp_max = h['temp-max']),
                f)
        break

infomsg("Shutting down")
sys.exit()
