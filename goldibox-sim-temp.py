#!/usr/bin/env python

import hal, time, sys, datetime, random

# Set up component
h = hal.component("sim-temp", timer=100)

# Inputs:
# - Peltier junction signals
h.newpin("p-enable", hal.HAL_BIT, hal.HAL_IN)
h.newpin("p-pos", hal.HAL_BIT, hal.HAL_IN)
h.newpin("p-neg", hal.HAL_BIT, hal.HAL_IN)
# - Fan signals
h.newpin("f-enable", hal.HAL_BIT, hal.HAL_IN)
h.newpin("f-pos", hal.HAL_BIT, hal.HAL_IN)
h.newpin("f-neg", hal.HAL_BIT, hal.HAL_IN)
# - User-set pretend outside temp
h.newpin("outside-temp", hal.HAL_FLOAT, hal.HAL_IN)
# - Incremental increase/decrease toward outside temp
h.newpin("outside-temp-incr", hal.HAL_FLOAT, hal.HAL_IN)
# - Incremental increase/decrease when heat/cool applied
h.newpin("heat-cool-incr", hal.HAL_FLOAT, hal.HAL_IN)

# Outputs:  
# - Simulated temp
h.newpin("value", hal.HAL_FLOAT, hal.HAL_OUT)
# - Error
h.newpin("error", hal.HAL_BIT, hal.HAL_OUT)

# Init values
h['value'] = 20 # Room temp
h['error'] = 0

def infomsg(msg):
    sys.stderr.write("%s Sim temp:  %s\n" %
                     (str(datetime.datetime.now()), msg))

# Mark the component as 'ready'
infomsg("Initialized")
h.ready()

i = 0
temp_base = h['value']
try:
    while True:
        time.sleep(0.1)
        i += 1

        # Take one sample for consistency
        # - Goldibox comp inputs
        p_enable = h['p-enable']
        p_pos = h['p-pos']
        p_neg = h['p-neg']
        f_enable = h['f-enable']
        f_pos = h['f-pos']
        f_neg = h['f-neg']
        # - User-defined inputs
        outside_temp = h['outside-temp']
        outside_temp_incr = h['outside-temp-incr']
        heat_cool_incr = h['heat-cool-incr']

        # Do some sanity checks
        err = 0
        if p_pos and p_neg:
            infomsg("Error:  p-pos and p-neg")
            err = 1
        if p_pos and not f_pos:
            infomsg("Error:  p-pos but not f-pos")
            err = 1
        if p_neg and not f_pos:
            infomsg("Error:  p-neg but not f-pos")
            err = 1
        if f_neg:
            infomsg("Error:  f-neg")
            err = 1
        if h['error'] and not err:
            infomsg("Error condition cleared")
        h['error'] = err

        # Set output value
        # - If it's warmer outside, increase; otherwise decrease
        if outside_temp > h['value']:
            temp_base += outside_temp_incr
        else:
            temp_base -= outside_temp_incr
        # - If heat is on, increase
        if p_neg:
            temp_base += heat_cool_incr
        # - If cool is on, decrease
        if p_pos:
            temp_base -= heat_cool_incr
        # - Add  random number btw. -1 and 1 to simulate thermistor variance
        newval = temp_base + random.triangular(-1,1,0)

        if i % 50 == 0:
            infomsg("Status:  outside=%.2f; value=%.2f(base %.2f);" %
                    (outside_temp, newval, temp_base))
            infomsg("         cool=%d; heat=%d, fan=%d" %
                    (p_pos, p_neg, f_pos))

        h['value'] = newval

except KeyboardInterrupt:
    infomsg("Exiting")
    sys.exit(0)


