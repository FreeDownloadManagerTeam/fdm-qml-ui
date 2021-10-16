import QtQuick 2.0
import QtQuick.Layouts 1.11

ColumnLayout {
    spacing: 0
    Rectangle {
        visible: appWindow.macVersion
        Layout.fillWidth: true
        height: appWindow.mainToolbarHeight
        color: "transparent"

        AppDragMoveMouseArea {
            anchors.fill: parent
            z: -1
        }
    }

    Rectangle {
        color: appWindow.theme.modalDimmingEffect
        opacity: 0.6
        Layout.fillWidth: true
        Layout.fillHeight: true

        MouseArea {
            anchors.fill: parent
        }
    }
}
