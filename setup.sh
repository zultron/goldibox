#!/bin/bash

# PocketBeagle pinouts:
# https://github.com/beagleboard/pocketbeagle/wiki/FAQ

sudo $(which config-pin) -f - <<- EOF

# PocketBeagle
# - Outputs
	P1.02	low	# In2/In3	Peltier -/hot
	P1.04	low	# In1/In4	Peltier +/cool
	P1.06	low	# ENA/ENB	Peltier enable
	P1.20	low	# MOSFET S	Fan on

# - Inputs
#	P1.17		VREFN	AIN/thermistor ground
#	P1.18		VREFP	AIN/thermistor 1.8V REF+
#	P1.19		AIN0	Thermistor input 0
#	P1.21		AIN1	Thermistor input 1
#	P1.23		AIN2	Thermistor input 2
#
#	P1.01		VIN-AC	Power input
#	P1.22		GND	Ground
EOF
