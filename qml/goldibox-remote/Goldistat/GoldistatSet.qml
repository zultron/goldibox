import QtQuick 2.0
import QtQuick.Controls 1.1

Item {
    id: base

    // Too Hot setting
    property alias redZone: red.value
    // Too Cold setting; needed to avoid overlap
    property alias blueZone: blue.value
    // Outside temperature and range; needed to compute angle
    property double tempOut: 30.0
    property double range: 90.0
    // Value display
    property int decimals: 1
    property string suffix: "°C"
    property double handleTextSize: 0.08
    property double handleTextOffset: 9

    // Min/max value and min Goldilocks zone
    property double minimumValue: tempOut - range/2
    property double maximumValue: tempOut + range/2
    property double minGreenZone: 2.0

    // Debugging
    // - Angles
    property alias redAngle: red.angle
    property alias blueAngle: blue.angle
    // - Mouse
    property double mouseX: 0.0
    property double mouseY: 0.0
    property int inring: 0
    property double totemp: 0.0
    property double dragged: 0.0
    // - Register
    property bool rzone: false
    property double rtemporig: 0.0
    property double rtempstart: 0.0
    property double newtemp: 0.0

    // Increment for mouse wheel
    property double stepSize: 0.2

    // Square
    height: width

    Canvas {
        /* Green background circle; exposed area represents "Just
         * Right" Goldilocks temperature zone */
        id: green

        contextType: "2d"
        smooth: true
        // Max size, on bottom
        anchors.fill: parent
        z: 0

        onPaint:
        {
            if (!context) {
                return;
            }

            context.reset();
            context.beginPath();
            // Green
            context.strokeStyle = "#00c000";
            context.lineWidth = width/4;
            // Slice is from 45 deg. NE to 45 deg. NW
            context.arc(width/2, height/2, width*3/8, 0, Math.PI * 2);
            context.stroke();
        }
    }

    Canvas {
        /* "Too Hot" red zone setting */
        id: red

        property double value: 25.0
        property alias tempOut: base.tempOut

        // Text readout with float format and degree units
        property string readout: value.toFixed(base.decimals) + base.suffix

        // Compute angle:
        // - (tempOut - range/2) .. (tempOut + range/2) => -.25PI .. 1.25PI
        property double angle: ((value - base.tempOut) /
                                base.range * -1.5 + 0.5) * Math.PI

        contextType: "2d"
        smooth: true
        // Max size, above green base
        anchors.fill: parent
        z: 1

        onAngleChanged: requestPaint()
        onValueChanged: requestPaint()
        onTempOutChanged: requestPaint()

        onPaint:
        {
            if (!context) {
                return;
            }

            context.reset();
            context.beginPath();
            // Red
            context.strokeStyle = "#ff0000";
            context.lineWidth = width/4;
            // Slice is from up/N to angle
            context.arc(width/2, height/2, width*3/8, Math.PI * -0.5, angle);
            context.stroke();
        }
    }

    Item {
        /* Readouts and gray border + circle at border of green and red */
        id: redBorder

        // This is a rectangular area centered on and wide as the dial
        // so that it may be rotated around its center as the zone
        // changes
        property double angle: red.angle
        anchors.fill: parent
        rotation: angle * 180 / Math.PI
        z: 2

        Rectangle {
            // Radial gray line at zone border
            id: redline
            width: parent.width/4
            height: parent.width/50
            color: "darkGray"
            x: parent.width * 3/4
            y: parent.height * (1/2 - 1/100)
        }

        Rectangle {
            // Round gray "handle" at zone border
            id: redhandle
            width: parent.width/12 // 1/3 of ring's width
            height: width
            radius: width/2
            color: "darkGray"
            x: parent.width * (3/4 + 1/12)
            y: parent.height * (1/2 - 1/24)
        }

        Label {
            // "Too Hot" temperature setting readout
            id: redreadout

            // Formatted float value in black text
            text: red.value.toFixed(base.decimals)
            color: "#000000"

            // Proportional size, centered above handle, with l/r tweak
            font.pixelSize: base.width * base.handleTextSize
            anchors.bottom: redhandle.top
            anchors.horizontalCenter: redhandle.horizontalCenter
            anchors.horizontalCenterOffset: -base.handleTextOffset
        }
    }

    Canvas {
        /* "Too Cold" blue zone setting */
        id: blue

        property double value: 15.0
        property double tempOut: base.tempOut

        // Text readout with float format and degree units
        property string readout: value.toFixed(base.decimals) + base.suffix

        // Compute angle:
        // - (tempOut - range/2) .. (tempOut + range/2) => -.25PI .. 1.25PI
        property double angle: ((value - base.tempOut) /
                                base.range * -1.5 + 0.5) * Math.PI

        contextType: "2d"
        smooth: true
        // Max size, above green base
        anchors.fill: parent
        z: 1

        onAngleChanged: requestPaint()
        onValueChanged: requestPaint()
        onTempOutChanged: requestPaint()

        onPaint:
        {
            if (!context) {
                return;
            }

            context.reset();
            context.beginPath();
            // Blue
            context.strokeStyle = "#0000ff";
            context.lineWidth = width/4;
            // Slice is from angle to up/N.
            context.arc(width/2, height/2, width*3/8, angle, Math.PI * 1.5);
            context.stroke();
        }
    }

    Item {
        /* Readouts and gray border + circle at border of green and blue */
        id: blueBorder

        // This is a rectangular area centered on and wide as the dial
        // so that it may be rotated around its center as the zone
        // changes
        property double angle: blue.angle
        anchors.fill: parent
        rotation: angle * 180 / Math.PI + 180
        z: 2

        Rectangle {
            // Radial gray line at zone border
            id: blueline
            width: parent.width/4
            height: parent.width/50
            color: "darkGray"
            x: 0
            y: parent.height * (1/2 - 1/100)
        }

        Rectangle {
            // Round gray "handle" at zone border
            id: bluehandle
            width: parent.width/12 // 1/3 of ring's width
            height: width
            radius: width/2
            color: "darkGray"
            x: parent.width * 1/12
            y: parent.height * (1/2 - 1/24)
        }

        Label {
            // "Too Cold" temperature setting readout
            id: bluereadout

            // Formatted float value in black text
            text: blue.value.toFixed(base.decimals)
            color: "#000000"

            // Proportional size, centered above handle, with l/r tweak
            font.pixelSize: base.width * base.handleTextSize
            anchors.bottom: bluehandle.top
            anchors.horizontalCenter: bluehandle.horizontalCenter
            anchors.horizontalCenterOffset: base.handleTextOffset
        }
    }

    Rectangle {
        /* Put a clear circle on top with gray borders to look purty */
        id: purty

        anchors.fill: parent
        radius: width/2
        color: "transparent"
        border.color: "darkGray"
        border.width: parent.width/50
        z: 8
    }

    MouseArea {
        id: events
        anchors.fill: parent
        z: 9 // On top

        // Saved state of initial mouse press
        property bool registerZone: true // true for red, false for blue
        property double registerTempOrig: 0.0 // temp before mouse press
        property double registerTempStart: 0.0 // temp where mouse pressed

        function mouseInRing(m) {
            // Calculate if click is in settings ring
            var dx = m.x - height/2;
            var dy = m.y - width/2;
            var d = Math.sqrt(Math.pow(dx,2) + Math.pow(dy,2));
            base.inring = d <= width/2 && d >= width/4; // FIXME
            return d <= width/2 && d >= width/4;
        }

        function mouseToTemp(m) {
            // Get angle in radians from straight up North
            var angle = Math.atan2(m.x - width/2, m.y - width/2);
            // Convert value to temperature
            var val = angle/Math.PI * base.range * 2/3 + base.tempOut;
            base.totemp = val; // FIXME
            return val;
        }

        // When pressed,
        // - If not pressed in ring, do nothing, stop.  Else,
        // - Check which zone the press was closest to
        // - Register the zone and starting temp
        onPressed: {
            if (!mouseInRing(mouse))
                return;
            var temp = mouseToTemp(mouse);
            if ((base.redZone - temp) < (temp - base.blueZone)) {
                // Closer to red
                registerZone = true;
                registerTempOrig = base.redZone;
            } else {
                // Closer to blue
                registerZone = false;
                registerTempOrig = base.blueZone;
            }
            registerTempStart = temp;
            // FIXME
            base.mouseX = mouse.x;
            base.mouseY = mouse.y;
            base.rzone = registerZone;
            base.rtemporig = registerTempOrig;
            base.rtempstart = registerTempStart;
        }
        // When moved, adjust the temperature by the amount dragged
        onPositionChanged: {
            // Get temp from mouse position
            var temp = mouseToTemp(mouse);
            // New temp will be orig temp adjusted by the amount dragged
            var newTemp = registerTempOrig + (temp - registerTempStart);
            if (registerZone) {
                // Red
                if (newTemp > base.maximumValue) newTemp = base.maximumValue;
                if (newTemp < blue.value + base.minGreenZone)
                    newTemp = blue.value + base.minGreenZone;
                red.value = newTemp;
            } else {
                if (newTemp < base.minimumValue) newTemp = base.minimumValue;
                if (newTemp > red.value - base.minGreenZone)
                    newTemp = red.value - base.minGreenZone;
                blue.value = newTemp;
            }
            // FIXME
            base.dragged = temp - registerTempStart;
            base.mouseX = mouse.x;
            base.mouseY = mouse.y;
            base.newtemp = newTemp;
        }

        // Mouse wheel:
        // - If not in ring, do nothing, stop.  Else,
        // - Check which zone mouse is closest to
        // - Increment/decrement the zone, respecting max/min values
        onWheel: {
            if (!mouseInRing(wheel))
                return;
            var temp = mouseToTemp(wheel);
            if ((base.redZone - temp) < (temp - base.blueZone)) {
                // Closest to red
                var newv = base.redZone + wheel.angleDelta.y/15 * base.stepSize;
                if (newv > base.maximumValue) newv = base.maximumValue;
                if (newv < base.blueZone + base.minGreenZone)
                    newv = base.blueZone + base.minGreenZone;
                base.redZone = newv;
            } else {
                // Closest to blue
                var newv = base.blueZone + wheel.angleDelta.y/15 * base.stepSize;
                if (newv < base.minimumValue) newv = base.minimumValue;
                if (newv > base.redZone - base.minGreenZone)
                    newv = base.redZone - base.minGreenZone;
                base.blueZone = newv;
            }
        }
    }

    Behavior on redZone {
        enabled: !events.pressed
        SmoothedAnimation { id: animate; duration: 800 }
    }
}
