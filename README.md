# Goldibox.  Not too hot, not too cold.

The Goldibox maintains temperature using a thermoelectric device and a
controller.  Originally conceived to incubate biological organisms
that thrive best within a particular maximum/minimum temperature
range, it can both heat and cool to avoid extremes, but still allow
variability within a habitable "Goldilocks zone":  not too hot, not
too cold, but just right.

The Goldibox's smart controller exposes a remote, network-connected
graphical interface for setting temperatures, checking current state,
and viewing history through time series graphs.  Anyone may modify the
open-source control to add new features.

This is currently a **work in progress**, and not all the features
discussed here are ready.

## Components

The Goldibox is based on an portable fridge.  These use a [Peltier
junction][wiki-peltier], which can be switched from a cooling element
to a heating element merely by reversing the voltage.  They are also
small, light and inexpensive, and can be found on eBay for about $40;
search for "portable fridge cooler warmer 110V".

The Goldibox controller, a tiny [PocketBeagle][pocketbeagle] computer,
fits in the cramped space next to the Peltier junction fan and heat
sink.  This small computer has the analog and digital interfaces to
control the hardware, and runs Debian and the control software.  They
sell for about $25 through official distributors, and also need a $10
micro SD card, a $5 [USB type A breakout module][usb-breakout] and a
$10 USB WiFi adapter.

The control functions come from the [Machinekit][machinekit] software
and its configuration in this repository.

The fridge is fitted with control electronics:  a thermistor and
circuitry for sensing temperature; an H-bridge for switching the
Peltier junction between cool, heat and off; and a MOSFET for
switching the fan.  These are small enough to easily fit inside the
fridge.  The H-bridge and MOSFET can be found integrated in
pre-assembled modules, and all parts are inexpensive and readily
available.  Search for "L298N motor driver module," "Mosfet Arduino
module," and "100k thermistor" on eBay, all around $5-$8.  The sensor
resistors and capacitors are inexpensive if not already in one's junk
box.  Also, a piece of Thermagon 6100 heat-conductive pad was used to
efficiently conduct temperature from the fridge to the thermistor.
The electronics can mostly be assembled with pre-assembled header
wires and a little soldering.

[wiki-peltier]: https://en.wikipedia.org/wiki/Thermoelectric_cooling
[pocketbeagle]: https://beagleboard.org/pocket
[usb-breakout]: https://github.com/zultron/fritzing-parts/tree/master/pocketbeagle-usb-type-a
[machinekit]: http://www.machinekit.io/


# Running

Follow the instructions at [machinekit.io][machinekit.io] to download
and install a mini-SD card image with Machinekit.

Log into the BeagleBone, clone this repository, and `cd` into the
repository directory.

Run the HAL configuration:

    ./mk-incubator.hal

Control the incubator from the command line:

    # Set incubator min, max and hysteresis params
    ./set.sh 15 30 2
    # Disable/enable the incubator without shutting down
    ./set.sh disable
    ./set.sh enable
    # Shut down the incubator
    ./set.sh shutdown

There is also a simulator configuration:

    ./incubator-sim.hal
    # Set simulated outdoor temp
    ./set.sh setsim 35

[machinekit.io]: http://machinekit.io

# Web interface

This is just beginning development and does nothing interesting yet.

```shell
# Build the Docker image
docker/qqvcp.sh build

# Build the AND demo
docker/qqvcp.sh anddemo-build

# Run the AND demo
docker/qqvcp.sh anddemo
# ...in debug mode
DEBUG=5 MSGD_OPTS=-s docker/qqvcp.sh anddemo
```


[L298_datasheet]: http://www.st.com/content/ccc/resource/technical/document/datasheet/82/cc/3f/39/0a/29/4d/f0/CD00000240.pdf/files/CD00000240.pdf/jcr:content/translations/en.CD00000240.pdf

[config-pin]: https://github.com/beagleboard/bb.org-overlays/tree/master/tools/beaglebone-universal-io

[pb-announce]: https://groups.google.com/d/topic/beagleboard/JtOGZb-FH2A/discussion
