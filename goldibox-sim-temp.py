#!/usr/bin/python

import hal, time, sys, datetime, random

# Set up component
h = hal.component("sim-temp", timer=100)

# Inputs:
# - Peltier junction signals
h.newpin("p-enable", hal.HAL_BIT, hal.HAL_IN)
h.newpin("p-heat", hal.HAL_BIT, hal.HAL_IN)
h.newpin("p-cool", hal.HAL_BIT, hal.HAL_IN)
# - Fan signals
h.newpin("f-enable", hal.HAL_BIT, hal.HAL_IN)
h.newpin("f-on", hal.HAL_BIT, hal.HAL_IN)
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
        p_heat = h['p-heat']
        p_cool = h['p-cool']
        f_enable = h['f-enable']
        f_on = h['f-on']
        # - User-defined inputs
        outside_temp = h['outside-temp']
        outside_temp_incr = h['outside-temp-incr']
        heat_cool_incr = h['heat-cool-incr']

        # Do some sanity checks
        err = 0
        if p_heat and p_cool:
            infomsg("Error:  p-heat and p-cool")
            err = 1
        if p_heat and not f_on:
            infomsg("Error:  p-heat but not f-on")
            err = 1
        if p_cool and not f_on:
            infomsg("Error:  p-cool but not f-on")
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
        if p_cool:
            temp_base += heat_cool_incr
        # - If cool is on, decrease
        if p_heat:
            temp_base -= heat_cool_incr
        # - Add  random number btw. -1 and 1 to simulate thermistor variance
        newval = temp_base + random.triangular(-1,1,0)

        if i % 500 == 0:
            infomsg("Status:  outside=%.2f; value=%.2f(base %.2f);" %
                    (outside_temp, newval, temp_base))
            infomsg("         cool=%d; heat=%d, fan=%d" %
                    (p_heat, p_cool, f_on))

        h['value'] = newval

except KeyboardInterrupt:
    infomsg("Exiting")
    sys.exit(0)


