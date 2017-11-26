import QtQuick 2.0
import QtQuick.Controls 1.1
import Machinekit.HalRemote 1.0
import "Private" as Private

Item {
    /* Outside temperature */
    property alias tempOutName: outGauge.pinName
    property double tempOut: 30.0
    /* Inside temperature */
    property alias tempInName: inGauge.pinName
    property double tempIn: 20.0
    /* Too Cold:  Lower boundary of Goldilocks zone */
    property alias blueZoneName: set.pinMinName
    property double blueZone: 15.0
    /* Too Hot:  Upper boundary of Goldilocks zone */
    property alias redZoneName: set.pinMaxName
    property double redZone: 25.0
    /* Range in degrees for allowed setting; centers around tempOut */
    property double range: 90.0

    /* Computed angle for inside temp pointer */
    property double angleIn: (tempOut - tempIn) / (range/2) * 135

    /* Synch */
    property bool synced: set.synced && inGauge.synced && outGauge.synced

    // Debugging
    // - Angles
    property double redAngle: set.redAngle
    property double blueAngle: set.blueAngle
    // - Mouse
    property double mouseX: set.mouseX
    property double mouseY: set.mouseY
    property alias inring: set.inring
    property double totemp: set.totemp
    property double dragged: set.dragged
    // - Register
    property int rzone: set.rzone
    property double rtemporig: set.rtemporig
    property double rtempstart: set.rtempstart

    // Increment for mouse wheel
    property double stepSize: 0.1

    id: root
    height: width * 1.35

    Private.GoldistatOut {
        id: outGauge
        z: 1

        /* Fits root item */
        anchors.fill: parent

        Binding {
            target: outGauge;
            property: "value";
            value: root.tempOut;
        }
    }


    Private.GoldistatIn {
        id: inGauge
        angle: root.angleIn

        /* This circle centers on the settings dial */
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.left: parent.left
        height: width
        z: 0

        Binding {
            target: inGauge;
            property: "blueZone";
            value: root.blueZone;
        }
        Binding {
            target: inGauge;
            property: "redZone";
            value: root.redZone;
        }
        Binding {
            target: inGauge;
            property: "value";
            value: root.tempIn;
        }
    }

    Private.GoldistatSet {
        id: set
        height: width
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.top: parent.top
        z: 2
        tempOut: root.tempOut
    }
}
