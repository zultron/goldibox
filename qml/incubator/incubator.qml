import QtQuick 2.0
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1
import Machinekit.Controls 1.0
import Machinekit.HalRemote.Controls 1.0
import Machinekit.HalRemote 1.0

HalApplicationWindow {
    id: main

    name: "incubator"
    title: qsTr("Goldilocks Incubator")

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10

        Item {
            Layout.fillHeight: true
        }

	// Incoming

	// Floats:  temp-cur

	// Outgoing
	// Sliders:  temp-max; temp-min; hysteresis
	// Sliders-sim:  outside-temp; outside-temp-incr; heat-cool-incr

        HalButton {
            Layout.alignment: Layout.Center
            name: "shutdown"
            text: "Shut down incubator"
        }

        HalButton {
            Layout.alignment: Layout.Center
            name: "enable"
            text: "Enable incubator"
            checkable: true
        }

        HalLed {
            Layout.alignment: Layout.Center
	    name: "error"
	    text: "Error"
        }

        HalLed {
            Layout.alignment: Layout.Center
	    name: "shutdown"
	    text: "Shut down"
        }

        HalLed {
            Layout.alignment: Layout.Center
	    name: "p-pos"
	    text: "Peltier junction pos"
        }

        HalLed {
            Layout.alignment: Layout.Center
	    name: "p-neg"
	    text: "Peltier junction negative"
        }

        HalLed {
            Layout.alignment: Layout.Center
	    name: "switch-on"
	    text: "On/off switch"
        }

        HalLed {
            Layout.alignment: Layout.Center
	    name: "switch-heat"
	    text: "Heat/cool selector"
        }

        HalLed {
            Layout.alignment: Layout.Center
	    name: "sim-error"
	    text: "Simulator detected error"
        }

        Label {
            Layout.fillWidth: true
            text: "Hello World!\n(label)"
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
        }
        Item {
            Layout.fillHeight: true
        }
    }
}

