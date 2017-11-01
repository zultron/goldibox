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
        id: background
        x: 0
        y: 0
        width: 500
        height: 800
        source: "assets/background.png"
    }

    ColumnLayout {
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 50
        anchors.top: locks_image.bottom
        anchors.topMargin: 0
        anchors.leftMargin: 100
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.left: parent.left
        anchors.margins: 10


        RowLayout {
            id: shutdown_enable_row
            width: 100
            height: 100
            Layout.fillWidth: false
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter


            HalSwitch {
                id: enable
                name: "enable"
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                checked: true
            }


            Label {
                id: enable_label
                text: qsTr("Enable")
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            }
            HalButton {
                id: shutdown_button
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                name: "shutdown"
                text: "Shut down"
                tooltip: "Shut down Goldibox control"
            }
        }

        RowLayout {
            id: temp_row
            width: 100
            height: 100
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter


            ColumnLayout {
                id: temp_min_col
                width: 100
                height: 100

                HalDial {
                    id: temp_min
                    name: "temp-min"
                    suffix: "°C"
                    decimals: 1
                    maximumValue: 40
                    minimumValue: 0
                }

                Label {
                    id: temp_min_label
                    text: qsTr("Min")
                }
            }
            ColumnLayout {
                id: temp_max_col
                width: 100
                height: 100

                HalDial {
                    id: temp_max
                    name: "temp-max"
                    suffix: "°C"
                    decimals: 1
                    minimumValue: 10
                    maximumValue: 50
                }

                Label {
                    id: temp_max_label
                    text: qsTr("Max")
                }
            }

            ColumnLayout {
                id: status_led_col
                width: 100
                height: 100

                RowLayout {
                    id: heat_led_row
                    width: 100
                    height: 100

                    HalLed {
                        id: p_heat
                        Layout.alignment: Layout.Center
                        name: "p-heat"
                        onColor: qsTr("#ff0000")
                    }

                    Label {
                        id: heat_led_label
                        text: qsTr("Heat")
                    }
                }

                RowLayout {
                    id: cool_led_row
                    width: 100
                    height: 100

                    HalLed {
                        id: p_cool
                        Layout.alignment: Layout.Center
                        name: "p-cool"
                        onColor: "#0000ff"
                    }

                    Label {
                        id: cool_led_label
                        text: qsTr("Cool")
                    }
                }

                RowLayout {
                    id: on_led_row
                    width: 100
                    height: 100

                    HalLed {
                        id: switch_on
                        Layout.alignment: Layout.Center
                        name: "switch-on"
                        onColor: "#00ff00"
                    }

                    Label {
                        id: on_led_label
                        text: qsTr("On")
                    }
                }

                RowLayout {
                    id: error_led_row
                    width: 100
                    height: 100

                    HalLed {
                        id: error
                        Layout.alignment: Layout.Center
                        name: "error"
                        onColor: "#ffa500"
                    }

                    Label {
                        id: error_led_label
                        text: qsTr("Error")
                    }
                }
            }
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
                Layout.minimumHeight: 20
                Layout.minimumWidth: 100
                suffix: "°C"
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                prefix: ""
                orientation: 1
                Layout.fillWidth: true
            }

            HalGauge {
                id: temp_ext
                name: "temp-ext"
                Layout.minimumHeight: 20
                Layout.minimumWidth: 100
                suffix: "°C"
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                Layout.fillWidth: true
            }

            Label {
                id: label
                text: qsTr("Temp int/ext")
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            }
        }
    }
}

