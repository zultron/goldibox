import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Button {
    /* Power button

       Simple, round O/1 power button
     */

    style: ButtonStyle {
	background: Item {
	    Rectangle {
		/* Base circle */

		// Center on parent, on bottom
		anchors.horizontalCenter: parent.horizontalCenter
		anchors.verticalCenter: parent.verticalCenter
		z: 0

		// Circle fills parent
		height: parent.height
		width: height
		radius: width/2

		// Color
		color: "#626262"
	    }

	    Canvas {
		/* I/O symbol */

		// Parameters
		// - I line geometry:  ratios to base height
		property double lineTop: 0.15     // line top Y
		property double lineBot: 0.40     // line bot Y
		// - O arc geometry
		property double arcStart: 310     // start in degrees
		property double arcEnd: 230       // end in degrees
		property double arcRadius: 0.3    // radius ratio
		// - Line and color
		property double lineWidth: 0.15   // line width ratio
		property string lineCap: "round"  // line end style
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
		    context.arc(width/2, height/2,      // center
				width*arcRadius,        // radius
				arcStart * Math.PI/180, // arc start/end
				arcEnd * Math.PI/180);  //   in radians
		    // Draw I line:  top to bottom
		    context.moveTo(width/2, height * lineTop);
		    context.lineTo(width/2, height * lineBot);
		    // Stroke line and arc with width, cap and color
		    context.strokeStyle = lineColor;
		    context.lineWidth = width * lineWidth;
		    context.lineCap = lineCap;
		    context.stroke();
		}
	    }
	}
    }
}
