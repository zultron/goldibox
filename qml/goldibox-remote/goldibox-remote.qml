import QtQuick 2.0
import QtQuick.Controls 1.1
import Machinekit.HalRemote.Controls 1.0
import Machinekit.HalRemote 1.0
import "Goldistat" as Goldistat

HalApplicationWindow {
    id: main
    name: "goldibox-remote"
    width: 500
    height: 800
    color: "#000000"
    transformOrigin: Item.Center
    title: qsTr("Goldibox")

    Item {
        id: goldibox
        anchors.fill: parent

        Image {
	    /* Fridge background image */
            id: fridge
            source: "assets/background.png"

            // Scale to fit window, keeping aspect, on bottom
            anchors.fill: parent
            fillMode: Image.PreserveAspectFit
	    z: 0
        }

        Goldistat.Goldistat {
	    /* Goldibox thermostat control */
            id: goldistat

	    // Middle layer
	    z: 5

	    // Relative sizing hell:  Constants determined empirically
            width: fridge.paintedWidth * 0.62
            anchors.horizontalCenter: fridge.horizontalCenter
            anchors.horizontalCenterOffset: fridge.paintedHeight * -0.04
            anchors.verticalCenter: fridge.verticalCenter
            anchors.verticalCenterOffset: fridge.paintedWidth * 0.42
            rotation: 55

        }

        Image {
	    /* Goldilocks */
            id: locks
            source: "assets/locks.png"

            // Scaled to fridge's actual image area, keeping aspect, on top
            anchors.fill: parent
            fillMode: Image.PreserveAspectFit
            z: 6

        }

        Image {
	    /* Fake (for now) graph */
            id: graph
            source: "assets/graph.png"

            // Scaled to fridge's actual image area, keeping aspect, on top
            anchors.fill: parent
            fillMode: Image.PreserveAspectFit
            z: 7

        }

        Goldistat.PowerButton {
            id: powerButton

	    // Geometry
	    width: fridge.paintedWidth * 0.12
            height: fridge.paintedWidth * 0.12
            anchors.horizontalCenter: fridge.horizontalCenter
            anchors.horizontalCenterOffset: fridge.paintedWidth * 0.28
            anchors.verticalCenter: fridge.verticalCenter
            anchors.verticalCenterOffset: fridge.paintedHeight * -0.28
        }

        Goldistat.ExitButton {
            id: exitButton

	    // Geometry
	    width: fridge.paintedWidth * 0.12
            height: fridge.paintedWidth * 0.12
            anchors.horizontalCenter: fridge.horizontalCenter
            anchors.horizontalCenterOffset: fridge.paintedWidth * -0.41
            anchors.verticalCenter: fridge.verticalCenter
            anchors.verticalCenterOffset: fridge.paintedHeight * -0.44
        }

    }

}

