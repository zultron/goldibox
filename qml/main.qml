import QtQuick 2.0
import QtQuick.Controls 1.1
import Machinekit.Application 1.0
import Machinekit.Application.Controls 1.0
import Machinekit.Service 1.0

ApplicationWindow {
    id: applicationWindow

    visible: true
    width: 700
    height: 500
    title: connectionWindow.title

    ConnectionWindow {
        id: connectionWindow

        anchors.fill: parent
        defaultTitle: "Goldibox"
        //autoSelectInstance: true
        autoSelectApplication: true
        /* mode: "local" */
        applications: [
            ApplicationDescription {
                sourceDir: "qrc:/goldibox/"
            }
        ]
        instanceFilter: ServiceDiscoveryFilter{ name: "" }
    }
}


