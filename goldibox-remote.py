#!/usr/bin/python
from machinekit import hal
import sys, datetime, yaml, os
persist_fname = "goldibox.conf.yaml"

def infomsg(msg):
    sys.stderr.write("%s Goldibox remote:  %s\n" %
                     (str(datetime.datetime.now()), msg))


# Read saved settings
if os.path.exists(persist_fname):
    with open(persist_fname, 'r') as f:
        saved_state = yaml.load(f)

# Create remote component
rcomp = hal.RemoteComponent('goldibox-remote', timer=100)

# Pin creation data
data = [
    # Controls
    ('enable', hal.HAL_BIT, hal.HAL_OUT),
    ('shutdown-button', hal.HAL_BIT, hal.HAL_OUT),
    ('temp-max', hal.HAL_FLOAT, hal.HAL_OUT),
    ('temp-min', hal.HAL_FLOAT, hal.HAL_OUT),
    # Readouts
    ('error', hal.HAL_BIT, hal.HAL_IN),
    ('cool-on', hal.HAL_BIT, hal.HAL_IN),
    ('heat-on', hal.HAL_BIT, hal.HAL_IN),
    ('switch-on', hal.HAL_BIT, hal.HAL_IN),
    ('temp-int', hal.HAL_FLOAT, hal.HAL_IN),
    ('temp-ext', hal.HAL_FLOAT, hal.HAL_IN),
]

for name, hal_type, hal_dir in data:
    pin = rcomp.newpin(name, hal_type, hal_dir)
    if name in saved_state:
        pin.set(saved_state[name])
        infomsg("Restored setting %s = %s" % (name,pin.get()))
    sig = hal.newsig(name, hal_type)
    pin.link(sig)

rcomp.ready()
infomsg("Initialized")
