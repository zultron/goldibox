import QtQuick 2.0
import QtQuick.Controls 1.1

Item {
    /* Inside temperature dial */
    id: base

    property alias text: temp.text
    property double value: 10.0
    property int decimals: 1
    property string suffix: "°C"
    property double blueZone: 15.0
    property double redZone: 25.0
    property double angle: 0.0

    // Text readout with float format and degree units
    property string readout: value.toFixed(decimals) + suffix
    // Color changes blue to green to red
    property color rgbColor: (value <= blueZone) ? "#0000ff" :
        ((value >= redZone) ? "#ff0000" : "#00c000")

    // Angle changes with readout
    rotation: angle
    // Circular and non-interactive
    height: width
    enabled: false

    // Layout
    property double ptrHeight:     0.125

    Rectangle {
        /* Red/Green/Blue circle changes color depending on the
         * current temperature */
        id: rgb

        // Circular
        width: base.height/2
        height: width
        radius: width/2
        // Centered on base
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        // Non-interactive
        enabled: false
        // Color changes depending on temperature
        color: base.rgbColor
        // Gray outline
        border.color: "darkGray"
        border.width: parent.width/50

    }

    Canvas {
        /* Black triangular pointer representing inside temp gauge */
        id: ptr

        contextType: "2d"
        smooth: true

        // Point outward to the edge of the rgb circle
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: rgb.bottom

        // Fixed aspect ratio
        width: base.width * (ptrHeight * 30 / 25)
        height: base.width * ptrHeight

        onPaint:
        {
            var context = getContext("2d");

            /* if (!context) return; */

            context.reset();
            // Fill with black
            context.fillStyle = "#000000";
            /* context.fillStyle = "black"; */
            context.beginPath();
            // Upper left
            context.moveTo(0, 0);
            // Trace across, then down and back to point
            context.lineTo(width, 0);
            context.lineTo(width/2, height);
            context.fill();

        }
    }

    Text {
        /* "IN" text */
        id: inText
        text: qsTr("IN")
        anchors.bottom: temp.top
        anchors.horizontalCenter: temp.horizontalCenter
        font.pixelSize: parent.width * 0.07
    }

    Label {
        /* Temperature readout */
        id: temp

        // Black text
        text: base.readout
        color: "#000000"

        // Center-justified, proportional
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: base.width * 0.10

        // Centered just above the pointer
        anchors.bottom: ptr.top
        anchors.horizontalCenter: ptr.horizontalCenter
    }
}
