#!/usr/bin/env python

import hal, time, sys

# Set up component
h = hal.component("incubator")

# Inputs:
# - Min/max/current temp settings
h.newpin("temp-min", hal.HAL_FLOAT, hal.HAL_IN)
h.newpin("temp-max", hal.HAL_FLOAT, hal.HAL_IN)
h.newpin("temp-cur", hal.HAL_FLOAT, hal.HAL_IN)
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
h['error'] = h['temp-max'] <= h['temp-min']
h['switch-on'] = 0
h['switch-heat'] = 0

# Mark the component as 'ready'
sys.stderr.write("Incubator component:  initialized\n")
h.ready()



while True:
    time.sleep(0.1)

    # Exit
    if h['shutdown']:
        sys.stderr.write(
            "Incubator component:  got shutdown signal = %s\n" % h['shutdown'])
        break

    # Error condition:  temp-max <= temp-min
    if h['temp-max'] <= h['temp-min']:
        h['switch-on'] = 0
        h['error'] = 1
        continue
    else:
        h['error'] = 0

    # Enable input
    if not h['enable']:
        # Disable
        h['switch-on'] = 0
        continue

    # Heat/cool selector switch
    temp_midpoint = (h['temp-min'] + h['temp-max']) / 2.0
    h['switch-heat'] = h['temp-cur'] < temp_midpoint

    # On/off switch
    h['switch-on'] = (h['temp-cur'] > h['temp-max']) or \
                     (h['temp-cur'] < h['temp-min'])

sys.stderr.write("Incubator component:  exiting\n")

# Shut things off
h['switch-on'] = 0

# Exit
sys.exit(0)
