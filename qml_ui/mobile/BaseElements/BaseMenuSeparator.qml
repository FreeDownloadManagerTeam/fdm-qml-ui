import QtQuick
import QtQuick.Controls

MenuSeparator {
    implicitHeight: visible ? 15 : 0
    contentItem: Rectangle {
        visible: true
        implicitHeight: visible ? 1 : 0

        Rectangle {
            width: parent.width
            anchors.verticalCenter: parent.verticalCenter
            implicitHeight: 1
            color: appWindow.theme.border
        }
    }
}
