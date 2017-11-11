import QtQuick 2.0
import QtQuick.Controls 1.1


Item {
    /* Outside temperature readout and pointer */
    id: base

    property double value: 30.0
    property int decimals: 1
    property string suffix: "°C"

    // Text readout with float format and degree units
    property string readout: value.toFixed(decimals) + suffix

    // Layout
    property double ptrHeight:     0.125
    property double outTextHeight: 0.070
    property double tempHeight:    0.100

    // Fixed aspect ratio and non-interactive
    height: width * (1.0 + ptrHeight + outTextHeight + tempHeight)
    enabled: false

    Canvas {
        /* Black triangular pointer representing outside temp gauge */
        id: ptr

        contextType: "2d"
        smooth: true
        // Always point up/inward to very bottom of base circle
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: base.width

        // SVG source shape, native 30x25 px
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
            // Tip of point
            context.moveTo(width/2, 0);
            // Trace to side and down, and then across
            context.lineTo(0, height);
            context.lineTo(width, height);
            context.lineTo(width/2, 0);
            context.fill();

        }
    }

    Label {
        /* Temperature readout */
        id: temp

        // Black text
        text: base.readout
        color: "#000000"

        // Centered just below the pointer
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: base.width * (1.0 + ptrHeight)
        font.pixelSize: base.width * tempHeight
    }

    Text {
        /* "OUT" text */
        id: outText
        text: qsTr("OUT")
        // Centered just below readout in smaller text
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: base.width * (1.0 + ptrHeight + tempHeight)
        font.pixelSize: parent.width * outTextHeight
    }
}
