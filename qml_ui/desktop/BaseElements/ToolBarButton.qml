import QtQuick 2.12
import "../../common"

Rectangle
{
    id: root

    property url source
    property bool indicator: false
    property bool rotate: false
    property string tooltipText

    signal clicked()

    color: "transparent"

    implicitHeight: icon.implicitHeight
    implicitWidth: icon.implicitWidth

    Rectangle
    {
        id: icon

        implicitHeight: img.implicitHeight
        implicitWidth: img.implicitWidth

        color: "transparent"

        anchors.fill: parent

        WaSvgImage {
            id: img
            anchors.centerIn: parent
            opacity: root.enabled ? 1 : 0.3
            source: root.source

            RotationAnimator on rotation {
                from: 0;
                to: 360;
                loops: Animation.Infinite
                duration: 2000
                running: root.rotate
                onStopped: img.rotation = 0
            }
        }
    }

    Rectangle {
        visible: root.indicator
        anchors.right: icon.right
        anchors.bottom: icon.bottom
        anchors.rightMargin: 8
        anchors.bottomMargin: 8
        height: 8
        width: 8
        radius: 4
        color: "#40ca0a"
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        hoverEnabled: true
        onClicked: root.clicked()
        BaseToolTip {
            text: root.tooltipText
            visible: root.enabled && parent.containsMouse && text.length > 0
            fontSize: 11
        }
    }
}
