import QtQuick 2.0
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1
import Machinekit.Controls 1.0
import Machinekit.HalRemote.Controls 1.0
import Machinekit.HalRemote 1.0

HalApplicationWindow {
    id: main
    name: "goldibox-remote"
    width: 500
    height: 800
    color: "#000000"
    title: qsTr("Goldibox")

    BorderImage {
        id: fridge_image
        width: 500
        height: 800
        source: "assets/fridge.svg"
    }

    ColumnLayout {
        anchors.rightMargin: 83
        anchors.bottomMargin: 48
        anchors.leftMargin: 83
        anchors.topMargin: 456
        anchors.fill: parent
        anchors.margins: 10

        RowLayout {
            id: shutdown_enable_row
            width: 100
            height: 100


            HalSwitch {
                id: enable
                name: "enable"
                checked: true
            }


            Label {
                id: enable_label
                text: qsTr("Enable")
            }
            HalButton {
                id: shutdown_button
                Layout.alignment: Layout.Center
                name: "shutdown"
                text: "Shut down Goldibox"
            }

            HalLed {
                id: error
                Layout.alignment: Layout.Center
                name: "error"
            }

            Label {
                id: error_label
                text: qsTr("Error")
            }
        }

        RowLayout {
            id: error_row
            width: 100
            height: 100
        }

        RowLayout {
            id: peltier_row
            width: 100
            height: 100

            HalLed {
                id: p_heat
                Layout.alignment: Layout.Center
                name: "p-heat"
            }

            HalLed {
                id: p_cool
                Layout.alignment: Layout.Center
                name: "p-cool"
            }

            HalLed {
                id: switch_on
                Layout.alignment: Layout.Center
                name: "switch-on"
            }

            HalLed {
                id: switch_heat
                Layout.alignment: Layout.Center
                name: "switch-heat"
            }

            Label {
                id: peltier_label
                text: qsTr("Heat/Cool/On/HCSelect")
            }
        }

        RowLayout {
            id: temp_row
            width: 100
            height: 100

            ColumnLayout {
                id: temp_max_col
                width: 100
                height: 100

                HalDial {
                    id: temp_max
                    name: "temp-max"
                    decimals: 1
                    minimumValue: 20
                    maximumValue: 50
                }

                Label {
                    id: temp_max_label
                    text: qsTr("Max")
                }
            }

            ColumnLayout {
                id: temp_min_col
                width: 100
                height: 100

                HalDial {
                    id: temp_min
                    name: "temp-min"
                    decimals: 1
                    maximumValue: 50
                    minimumValue: 20
                }

                Label {
                    id: temp_min_label
                    text: qsTr("Min")
                }
            }

            ColumnLayout {
                id: hysteresis_col
                width: 100
                height: 100

                HalDial {
                    id: hysteresis
                    name: "hysteresis"
                    decimals: 1
                    maximumValue: 2
                    tickmarksEnabled: false
                }

                Label {
                    id: hysteresis_label
                    text: qsTr("Hyst")
                }
            }
        }

        Item {
            Layout.fillHeight: true
        }

        ColumnLayout {
            id: temp_col
            width: 100
            height: 100
            Layout.fillWidth: true

            HalGauge {
                id: temp_int
                name: "temp-int"
                radius: 3
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                prefix: ""
                orientation: 1
                Layout.fillWidth: true
            }

            HalGauge {
                id: temp_ext
                name: "temp-ext"
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                Layout.fillWidth: true
            }

            Label {
                id: label
                text: qsTr("Temp int/ext")
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            }
        }

        RowLayout {
            id: sim_row
            width: 100
            height: 100
        }
    }

    Image {
        id: locks_image
        x: 60
        y: 215
        width: 380
        height: 279
        fillMode: Image.PreserveAspectFit
        source: "assets/locks.svg"
    }
}

