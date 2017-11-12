import QtQuick 2.0
import QtQuick.Controls 1.1
import "Private"

Item {
    /* Outside temperature */
    property double tempOut: 30.0
    /* Inside temperature */
    property double tempIn: 10.0
    /* Too Cold:  Lower boundary of Goldilocks zone */
    property double blueZone: set.blueZone
    /* Too Hot:  Upper boundary of Goldilocks zone */
    property double redZone: set.redZone
    /* Range in degrees for allowed setting; centers around tempOut */
    property double range: 90.0

    /* Computed angle for inside temp pointer */
    property double angleIn: (tempOut - tempIn) / (range/2) * 135


    // Debugging
    // - Angles
    property double redAngle: set.redAngle
    property double blueAngle: set.blueAngle
    // - Mouse
    property double mouseX: set.mouseX
    property double mouseY: set.mouseY
    property int inring: set.inring
    property double totemp: set.totemp
    property double dragged: set.dragged
    // - Register
    property bool rzone: set.rzone
    property double rtemporig: set.rtemporig
    property double rtempstart: set.rtempstart

    // Increment for mouse wheel
    property double stepSize: 0.1

    id: root
    height: width * 1.35

    GoldistatOut {
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


    GoldistatIn {
        id: inGauge
        angle: root.angleIn
        value: root.tempIn

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
        Binding {
            target: inGauge;
            property: "angle";
            value: root.angleIn;
        }
    }

    GoldistatSet {
        id: set
        height: width
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.top: parent.top
        z: 2
        tempOut: root.tempOut
    }
}
