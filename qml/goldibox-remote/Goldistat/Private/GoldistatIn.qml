import QtQuick 2.0
import QtQuick.Controls 1.1

Item {
    /* Inside temperature gauge

       This circular dial indicates the inside temperature in a few ways:
       - Text readout:  displays formatted float value with units
       - Pointer:  entire dial, with pointer, rotates to indicate temperature
       - Color:  dial changes color to red/blue/green to indicate current zone
     */
    id: base

    // Parameters and settings
    // - Incoming parameters
    property double value: 10.0    // Measured inside temperature, for readout
    property double blueZone: 15.0 // "Too Cold" setting, for color
    property double redZone: 25.0  // "Too Hot" setting, for color
    property double angle: 20.0    // Angle of rotation, in degrees
    // - Settings for readout
    property int decimals: 1       // Format `value` readout decimal places
    property string suffix: "°C"   // Readout units, appended to value
    property color blue: "#0000ff"
    property color red: "#ff0000"
    property color green: "#00c000"
    property color readoutColor: "#000000"
    // - Pointer
    property color ptrcolor: "#000000"
    // - Text
    property string inTextStr: qsTr("IN")
    // - Layout:  ratio to base width
    property double diameter:  0.500          // dial diameter
    property double ptrHeight: 0.125          // ptr height
    property double ptrWidth: ptrHeight * 6/5 // ptr width
    property double readoutTextSize: 0.10     // readout text font height
    property double inTextSize: 0.07          // 'IN' text font height
    property double borderWidth: 0.02         // border thickness

    // Square frame for circular dial
    height: width
    // Change angle with readout
    rotation: angle

    Rectangle {
        /* Base circle */
        id: rgb

        // Size circle relative to frame
        width: base.height * base.diameter
        height: width
        radius: width/2

        // Center on base and lower
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
	z: 0

	// Change color depending on temperature zone
	color: (
	    (base.value <= base.blueZone) ? base.blue : // too cold
            ((base.value >= base.redZone) ? base.red :  // too hot
	     base.green))                               // just right

        // Outline in gray
        border.color: "darkGray"
        border.width: parent.width * borderWidth

    }

    Canvas {
        /* Black triangular pointer representing inside temp gauge */
        id: ptr

        contextType: "2d"

        // Center at bottom of dial, raise to top layer
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: rgb.bottom
	z: 1

        // Size relatively with fixed aspect ratio
        width: base.width * base.ptrWidth
        height: base.width * base.ptrHeight

	// Triangle points outward toward edge of rgb circle
        onPaint: {
            if (!context) return;
            context.reset();
            context.beginPath();
            // Start at upper left
            context.moveTo(0, 0);
            // Trace across, then down to point
            context.lineTo(width, 0);
            // Fill with color
            context.fillStyle = base.ptrcolor;
            context.fill();
        }
    }

    Text {
        /* "IN" text */
        id: inText
        text: base.inTextStr

	// Center text above readout with relative font size, raise to
	// top layer
        anchors.bottom: temp.top
        anchors.horizontalCenter: temp.horizontalCenter
        font.pixelSize: parent.width * base.inTextSize
	z: 1
    }

    Label {
        /* Temperature readout */
        id: temp

	// Text readout:  formatted float and units
        text: base.value.toFixed(decimals) + base.suffix

        // Size font proportionally and color text
        font.pixelSize: base.width * base.readoutTextSize
        color: base.readoutColor

        // Center text just above the pointer, raise to top layer
        anchors.bottom: ptr.top
        anchors.horizontalCenter: ptr.horizontalCenter
	z: 1
    }
}
