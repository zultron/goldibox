# Goldibox.  Not too hot, not too cold.

The Goldibox is an insulated box that maintains temperature using a
thermoelectric device and a controller.  Originally conceived to
incubate biological organisms that thrive best within a particular
maximum/minimum temperature range, it can both heat and cool to avoid
extremes, but still allow variability within a habitable "Goldilocks
zone":  not too hot, not too cold, but just right.

The Goldibox's smart controller exposes a remote, network-connected
graphical interface for setting temperatures, checking current state,
and viewing history through time series graphs.  Anyone may modify the
open-source control to add new features.

This is currently a **work in progress**, and not all the features
discussed here are ready.

![Goldibox](fritzing/goldibox-breadboard.png)

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
micro SD card for the OS, a $3 DC step-down converter to 5VDC power
from the 12VDC fridge power supply,  and a $5 [USB type A breakout
module][usb-breakout] and $10 USB WiFi adapter for networking.

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

    ./goldibox.hal

Control the goldibox from the command line:

    # Set goldibox min, max and hysteresis params
    ./set.sh 15 30 2
    # Disable/enable the goldibox without shutting down
    ./set.sh disable
    ./set.sh enable
    # Shut down the goldibox
    ./set.sh shutdown

There is also a simulator configuration that can be run from Docker:

    # Build Docker image
    docker/qqvcp.sh build
    # Run Docker container
    docker/qqvcp.sh
    # Start syslog, dbus and avahi services
    sudo /etc/init.d/rsyslog start
    sudo /etc/init.d/dbus start
    sudo /etc/init.d/avahi-daemon start
    # Run simulator
    ./goldibox-sim.hal
    # Set simulated outdoor temp
    ./set.sh setsim 35

[machinekit.io]: http://machinekit.io

# Installing the PocketBeagle

FIXME

https://eewiki.net/display/linuxonarm/PocketBeagle


```
minicom -D /dev/ttyACM0
ssh debian@192.168.6.2
pass:  temppwd
```

sudoers:  Don't require passwd for sudo and admin groups **UNSAFE**

```
sudo sed -i /etc/sudoers.d/admin \
    -e '/^%admin/ s/ALL=.*$/ALL=(ALL:ALL) NOPASSWD: ALL/'
sudo sed -i /etc/sudoers \
    -e '/^%sudo/ s/ALL=.*$/ALL=(ALL:ALL) NOPASSWD: ALL/'
```

Resize fs:
- https://elinux.org/Beagleboard:Expanding_File_System_Partition_On_A_microSD
- Use fdisk to delete & recreate part with same start sector
- Reboot
- Resize rootfs with `resize2fs /dev/mmcblk0p1`

From http://jpdelacroix.com/tutorials/sharing-internet-beaglebone-black.html
On host side:
```
sudo iptables -t nat -A POSTROUTING \! -o enx60640561b61f -s 192.168.6.2 -j MASQUERADE
sudo iptables -A FORWARD -i enx60640561b61f -j ACCEPT
sudo iptables -A FORWARD -o enx60640561b61f -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
```

On bb side:
```
sudo ip route add default via 192.168.6.1 dev usb1
```

```
# Clear root passwd
sudo sed -i /etc/shadow -e 's/^root:[^:]*:/root:*:/'

# Time zone
sudo ln -sf /usr/share/zoneinfo/America/Chicago /etc/localtime

# Kernel https://elinux.org/Beagleboard:BeagleBoneBlack_Debian#4.9.x-ti
sudo /opt/scripts/tools/update_kernel.sh --ti-rt-channel --lts-4_9

wget -O /tmp/arceye@mgware.co.uk.gpg.key http://deb.mgware.co.uk/arceye@mgware.co.uk.gpg.key
sudo apt-key add /tmp/arceye@mgware.co.uk.gpg.key
echo "deb http://deb.mgware.co.uk stretch main" | sudo tee /etc/apt/sources.list.d/
sudo apt-get update

sudo apt-get install emacs-nox
sudo apt-get install linux-image-4.11.12-bone-rt-r3
sudo apt-get install machinekit-rt-preempt
sudo apt-get install git
sudo apt-get install lsb-release
sudo apt-get install usbutils wireless-tools connman
sudo apt-get install avahi-daemon
sudo apt-get install python-rrdtool

sudo connmanctl agent on
sudo connmanctl enable wifi
sudo cat \
    > /var/lib/connman/wifi_48022ae12503_5a756c74726f6e40686f6d652d32_managed_psk \
    <<EOF
[wifi_0013ef2a079b_5a756c74726f6e40686f6d652d32_managed_psk]
Name=Zultron@home-2
SSID=5a756c74726f6e40686f6d652d32
Frequency=2422
Favorite=true
AutoConnect=true
Modified=2017-10-16T19:50:11.699608Z
Passphrase=$WIFI_PASS
IPv4.method=dhcp
IPv4.DHCP.LastAddress=192.168.7.157
IPv6.method=auto
IPv6.privacy=disabled
EOF
sudo chmod -x /opt/scripts/boot/autoconfigure_usb[01].sh
sudo sed -i /etc/network/interfaces -e '/eth0/ s/^/#/'
```


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
