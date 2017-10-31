# Misc notes

This is a big jumble of notes that needs organization.

## Installing the PocketBeagle


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

# Configure GPIOs low on boot
sudo dtc -O dtb -o /lib/firmware/pb_goldibox-00A0.dtbo -b 0 -@
pb_goldibox.dts
echo dtb_overlay=/lib/firmware/pb_goldibox-00A0.dtbo | sudo tee -a /boot/uEnv.txt
```


## Web interface

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


## Links

[L298_datasheet]: http://www.st.com/content/ccc/resource/technical/document/datasheet/82/cc/3f/39/0a/29/4d/f0/CD00000240.pdf/files/CD00000240.pdf/jcr:content/translations/en.CD00000240.pdf

[config-pin]: https://github.com/beagleboard/bb.org-overlays/tree/master/tools/beaglebone-universal-io

[pb-announce]: https://groups.google.com/d/topic/beagleboard/JtOGZb-FH2A/discussion
