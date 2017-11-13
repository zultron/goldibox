/****************************************************************************
**
** Copyright (C) 2014 Alexander Rössler
** License: LGPL version 2.1
**
** This file is part of QtQuickVcp.
**
** All rights reserved. This program and the accompanying materials
** are made available under the terms of the GNU Lesser General Public License
** (LGPL) version 2.1 which accompanies this distribution, and is available at
** http://www.gnu.org/licenses/lgpl-2.1.html
**
** This library is distributed in the hope that it will be useful,
** but WITHOUT ANY WARRANTY; without even the implied warranty of
** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
** Lesser General Public License for more details.
**
** Contributors:
** Alexander Rössler @ The Cool Tool GmbH <mail DOT aroessler AT gmail DOT com>
**
****************************************************************************/
import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0
import QtQuick.Window 2.0
import Machinekit.Controls 1.0

ApplicationWindow {
    id: mainWindow

    visible: true
    title: qsTr("Goldistat Demo")
    width: 700
    height: 500

    property double range: 90.0


    Item {
        id: goldibox
        anchors.right: parent.horizontalCenter
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.top: parent.top
        anchors.topMargin: 0
        anchors.bottom: parent.bottom

        Image {
	    /* Fridge background image */
            id: fridge
            source: "goldibox-remote/assets/background.png"

	    // Scale to fit window, keeping aspect, on bottom
            anchors.fill: parent
            fillMode: Image.PreserveAspectFit
	    z: 0
        }

        Goldistat {
	    /* Goldibox thermostat control */
            id: goldistat

            tempIn: inTemp.value
            tempOut: outTemp.value
            range: mainWindow.range

	    // Middle layer
	    z: 5

	    // Relative sizing hell:  Constants determined empirically
            width: fridge.paintedWidth * 0.73
            anchors.horizontalCenter: fridge.horizontalCenter
            anchors.horizontalCenterOffset: fridge.paintedHeight * 0.07
            anchors.verticalCenter: fridge.verticalCenter
            anchors.verticalCenterOffset: fridge.paintedWidth * 0.24
            rotation: -25

        }

        Image {
	    /* Goldilocks */
            id: locks
            source: "goldibox-remote/assets/locks.png"

	    // Scaled to fridge's actual image area, keeping aspect, on top
            anchors.fill: parent
            fillMode: Image.PreserveAspectFit
            z: 6
        }
    }

    ColumnLayout {
        id: columnLayout
        x: 375
        width: 300
        anchors.right: parent.right
        anchors.top: parent.top
        visible: true

        GroupBox {
            id: zoneg
            Layout.alignment: Qt.AlignLeft | Qt.AlignTop
            title: qsTr("Settings")

            Label {
                id: redZlabel
                x: 0
                y: 0
                text: "red: " + goldistat.redZone.toFixed(1)
            }

            Label {
                id: blueZlabel
                x: 110
                y: 0
                text: "blue: " + goldistat.blueZone.toFixed(1)
            }

            Label {
                id: redAlabel
                x: 0
                y: 20
                text: "red angle: " + (goldistat.redAngle * 180/Math.PI).toFixed(0)
            }

            Label {
                id: blueAlabel
                x: 110
                y: 20
                text: "blue angle: " + (goldistat.blueAngle * 180/Math.PI).toFixed(0)
            }
        }

        GroupBox {
            id: mouseg
            Layout.alignment: Qt.AlignLeft | Qt.AlignTop
            title: qsTr("Mouse")

            Label {
                id: mousex
                text: "x: " + goldistat.mouseX.toFixed(1)
            }

            Label {
                id: mousey
                x: 0
                y: 14
                text: "y: " + goldistat.mouseY.toFixed(1)
            }

            Label {
                id: inring
                x: 82
                y: 0
                text: "in ring: " + goldistat.inring
            }

            Label {
                id: totemp
                x: 82
                y: 14
                text: "to temp: " + goldistat.totemp.toFixed(1)
            }
        }

        GroupBox {
            id: regg
            width: 360
            height: 300
            title: qsTr("Register")

            Label {
                id: rzone
                x: 179
                y: 0
                text: "zone: " + goldistat.rzone
            }

            Label {
                id: rtemporig
                x: 95
                y: 40
                text: "previous setting: " + goldistat.rtemporig.toFixed(1)
            }

            Label {
                id: rtempstart
                x: 0
                y: 0
                text: "start pos: " + goldistat.rtempstart.toFixed(1)
            }

            Label {
                id: totemp2
                x: 6
                y: 20
                text: "cur pos: " + goldistat.totemp.toFixed(1)
            }

            Label {
                id: dragged
                x: 6
                y: 40
                text: "change: " + goldistat.dragged.toFixed(1)
            }
        }

        GroupBox {
            id: sliderg
            width: 360
            height: 300
            title: qsTr("Simulate Temp In/Out")

            Slider {
                id: inTemp
                x: 0
                y: 2
                value: 10
                minimumValue: -30
                maximumValue: 90
            }

            Slider {
                id: outTemp
                x: 0
                y: 23
                value: 30
                minimumValue: -30
                maximumValue: 90
            }
        }
    }
}
