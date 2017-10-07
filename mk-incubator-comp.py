#!/usr/bin/env python

import hal, time, sys, datetime

# Set up component
h = hal.component("incubator")

# Inputs:
# - Min/max/current temp settings
h.newpin("temp-min", hal.HAL_FLOAT, hal.HAL_IN)
h.newpin("temp-max", hal.HAL_FLOAT, hal.HAL_IN)
h.newpin("temp-cur", hal.HAL_FLOAT, hal.HAL_IN)
# - Hysteresis
h.newpin("hysteresis", hal.HAL_FLOAT, hal.HAL_IN)
# - Enable
h.newpin("enable", hal.HAL_BIT, hal.HAL_IN)
# - Exit
h.newpin("shutdown", hal.HAL_BIT, hal.HAL_IN)

# Outputs:  
# - On/off switch
h.newpin("switch-on", hal.HAL_BIT, hal.HAL_OUT)
# - Heat/cool selector switch (1/0)
h.newpin("switch-heat", hal.HAL_BIT, hal.HAL_OUT)
# - Error
h.newpin("error", hal.HAL_BIT, hal.HAL_OUT)

# Init values
h['error'] = (h['temp-max'] <= h['temp-min']) or (h['hysteresis'] < 0)
h['switch-on'] = 0
h['switch-heat'] = 0

def infomsg(msg):
    sys.stderr.write("%s Incubator component:  %s\n" %
                     (str(datetime.datetime.now()), msg))

# Mark the component as 'ready'
infomsg("Initialized")
h.ready()

while True:
    time.sleep(0.1)

    # Take one sample for consistency
    enable = h['enable']
    shutdown = h['shutdown']
    temp_cur = h['temp-cur']
    temp_max = h['temp-max']
    temp_min = h['temp-min']
    hysteresis = h['hysteresis']
    
    # Exit
    if shutdown:
        infomsg("Got shutdown signal = %s" % shutdown)
        break

    # Error condition:  temp-max <= temp-min
    if (temp_max <= temp_min) or (hysteresis < 0):
        if not h['error']:
            if temp_max <= temp_min:
                infomsg("ERROR:  temp_max <= temp_min")
            if hysteresis < 0:
                infomsg("ERROR:  hysteresis < 0")
        h['switch-on'] = 0
        h['error'] = 1
        continue
    else:
        if h['error']:
            infomsg("Recovered from error conditions")
        h['error'] = 0

    # Enable input
    if not enable:
        # Disable
        h['switch-on'] = 0
        continue


    # On/off and heat/cool switches
    if ((temp_cur - hysteresis) > temp_max):
        if not h['switch-on']:
            infomsg("Turning on cool; cur temp %.1f (hyst %.1f)" %
                    (temp_cur, hysteresis))
        h['switch-heat'] = 0
        h['switch-on'] = 1
    elif ((temp_cur + hysteresis) < temp_min):
        if not h['switch-on']:
            infomsg("Turning on heat; cur temp %.1f (hyst %.1f)" %
                    (temp_cur, hysteresis))
        h['switch-heat'] = 1
        h['switch-on'] = 1
    elif ((temp_cur > temp_min) and (temp_cur < temp_max)):
        if h['switch-on']:
            infomsg("Turning off; cur temp %.1f" % temp_cur)
        h['switch-on'] = 0



infomsg("Exiting")

# Shut things off
h['switch-on'] = 0

# Exit
sys.exit(0)
