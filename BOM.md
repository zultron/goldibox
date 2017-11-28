# Bill of materials

- Portable fridge
  - Search eBay for "portable fridge cooler warmer 110V", about $40
- Controller:
  - PocketBeagle computer
    - Shop official distributors, about $25
  - Micro SD card, class 10, 4GB or more, for PocketBeagle
    - About $10
  - [USB type A breakout module][usb-breakout], for PocketBeagle
    - Search eBay for "USB type A breakout module", about $5
  - USB WiFi adapter for networking
    - Look for a Raspberry Pi-compatible model, about $10
  - DC to 5VDC converter, provides 5V power to PocketBeagle
    - Search eBay for "DC step-down converter", about $5
- Power electronics:
  - H-bridge module for controlling Peltier
    - This project uses an L298N; you may find newer and better
      substitutes
    - Search eBay for "L298N motor driver module", about $5
  - MOSFET module for controlling fan
    - Search eBay for "Mosfet Arduino module", about $8
- Temperature sensing electronics:
  - Thermistor, 2 ea., 10k ohm at 25 deg. C.
    - Search eBay for "10k thermistor"
  - Resistors and capacitors:
    - Junk box, or eBay; see fritzing model for values
- Other parts:
  - Thermagon 6100 heat-conductive pad for conducting heat from fridge
    to internal thermistor
  - Header wires and solder
  - Heat-shrink tubing and custom-crimped connectors improve appearance

[usb-breakout]: https://github.com/zultron/fritzing-parts/tree/master/pocketbeagle-usb-type-a
