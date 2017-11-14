import QtQuick 2.0

Item {
    /* Power button

       Simple, round O/1 power button
     */
    id: base

    // Parameters and settings
    // - Power on signal
    property alias powerOn:  events.powerOn    // Power on signal
    // - Line and color
    property alias baseColor: circle.baseColor // Color of base circle, gray
    property alias lineColor: symbol.lineColor // Color of symbol lines
    property alias lineWidth: symbol.lineWidth // ratio of line width to base width
    property alias lineCap: symbol.lineCap     // line end style:  butt, round, square
    // - I line
    property alias lineTop: symbol.lineTop     // ratio of line top Y to base height
    property alias lineBot: symbol.lineBot     // ratio of line bot Y to base height
    // - O arc geometry
    property alias arcStart: symbol.arcStart   // start in degrees
    property alias arcEnd: symbol.arcEnd       // end in degrees
    property alias arcRadiue: symbol.arcRadius // ratio of radius to base width

    Rectangle {
        /* Base circle */
        id: circle

	// Parameters
	property color baseColor: "#626262"

        // Center on base, on bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        z: 0

	// Circle fills base
	height: base.height
	width: height
	radius: width/2

	// Color
	color: baseColor
    }

    Canvas {
        /* I/O symbol */
        id: symbol

	// Parameters
	// - I line geometry
	property double lineTop: 0.15     // ratio of line top Y to base height
	property double lineBot: 0.40     // ratio of line bot Y to base height
	// - O arc geometry
	property double arcStart: 310     // start in degrees
	property double arcEnd: 230       // end in degrees
	property double arcRadius: 0.3    // ratio of radius to base width
	// - Line and color
	property double lineWidth: 0.15   // ratio of line width to base width
	property string lineCap: "round"  // line end style:  butt, round, square
	property color lineColor: "black" // Color of lines

        // Max size, on top
        anchors.fill: parent
        z: 1

	// Draw the symbol
        contextType: "2d"
        onPaint: {
            if (!context) return;
            context.reset();
            context.beginPath();
            // Draw O arc
            context.arc(width/2, height/2,              // center
			width*arcRadius,                // radius
			arcStart * Math.PI/180,         // arc start/end
			arcEnd * Math.PI/180);          //   in radians
	    // Draw I line
	    context.moveTo(width/2, height * lineTop);  // move to top
	    context.lineTo(width/2, height * lineBot);  // trace to bottom
            // Stroke line and arc with width, cap and color
            context.strokeStyle = lineColor;
            context.lineWidth = width * lineWidth;
	    context.lineCap = lineCap;
            context.stroke();
        }
    }

    MouseArea {
	/* Invisible layer for dealing with mouse button and scroll input

	   When button is clicked, just set signal to true and leave
	   it that way.
	  */
        id: events

	// Process clicks from full area, and be on top
        anchors.fill: parent
        z: 9 // On top

        // Power on signal
	property bool powerOn:  true

        // When released, set powerOn to false
        onReleased: {
	    powerOn = false;
        }
    }
}
