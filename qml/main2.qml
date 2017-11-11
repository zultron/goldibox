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

    property alias redZone: goldistat.redZone
    property alias blueZone: goldistat.blueZone
    property alias redAngle: goldistat.redAngle
    property alias blueAngle: goldistat.blueAngle

    property double range: 90.0

    // - Mouse
    property double mouseX: goldistat.mouseX
    property double mouseY: goldistat.mouseY
    property int inring: goldistat.inring
    property double totemp: goldistat.totemp
    property double dragged: goldistat.dragged
    // - Register
    property bool rzone: goldistat.rzone
    property double rtemporig: goldistat.rtemporig
    property double rtempstart: goldistat.rtempstart


    Item {
        id: goldibox
        width: 400
        height: 500

        Image {
            id: image
            anchors.fill: parent
            fillMode: Image.PreserveAspectFit
            source: "goldibox-remote/assets/background.png"
        }

        Goldistat {
            id: goldistat
            x: 32
            y: 0
            anchors.rightMargin: -32
            anchors.leftMargin: 32
            anchors.topMargin: 0
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top

            tempIn: inTemp.value
            tempOut: outTemp.value
            range: mainWindow.range
        }
    }

    ColumnLayout {
        id: columnLayout
        x: 375
        width: 300
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.top: parent.top
        visible: true

        GroupBox {
            id: zoneg
            Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
            title: qsTr("red/blue zone")

            Label {
                id: redZlabel
                text: mainWindow.redZone.toFixed(1)
            }

            Label {
                id: blueZlabel
                x: 34
                y: 0
                text: mainWindow.blueZone.toFixed(1)
            }
        }

        GroupBox {
            id: mouseg
            Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
            title: qsTr("mouse x/y/inring/totemp/dragged")

            Label {
                id: mousex
                text: mainWindow.mouseX.toFixed(1)
            }

            Label {
                id: mousey
                x: 39
                y: 0
                text: mainWindow.mouseY.toFixed(1)
            }

            Label {
                id: inring
                x: 78
                y: 0
                text: mainWindow.inring
            }

            Label {
                id: totemp
                x: 117
                y: -1
                text: mainWindow.totemp.toFixed(1)
            }

            Label {
                id: dragged
                x: 156
                y: -1
                text: mainWindow.dragged.toFixed(1)
            }
        }

        GroupBox {
            id: angleg
            width: 360
            height: 300
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            title: qsTr("red/blue angle")

            Label {
                id: redAlabel
                text: mainWindow.redAngle.toFixed(2)
            }

            Label {
                id: blueAlabel
                x: 34
                y: 0
                text: mainWindow.blueAngle.toFixed(2)
            }
        }

        GroupBox {
            id: regg
            width: 360
            height: 300
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            title: qsTr("register zone/temporig/tempstart")

            Label {
                id: rzone
                text: mainWindow.rzone
            }

            Label {
                id: rtemporig
                x: 39
                y: 0
                text: mainWindow.rtemporig.toFixed(1)
            }

            Label {
                id: rtempstart
                x: 86
                y: 0
                text: mainWindow.rtempstart.toFixed(1)
            }
        }

        GroupBox {
            id: sliderg
            width: 360
            height: 300
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            title: qsTr("Adjust Temp In/Out")

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
