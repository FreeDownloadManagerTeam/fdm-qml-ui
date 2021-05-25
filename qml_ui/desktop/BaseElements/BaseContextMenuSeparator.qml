import QtQuick 2.0
import QtQuick.Controls 2.4

MenuSeparator {

    contentItem: Rectangle {
        visible: true
        implicitHeight: visible ? 7 : 0
        color: "transparent"

        Rectangle {
            width: parent.width
            anchors.verticalCenter: parent.verticalCenter
            implicitHeight: 1
            color: appWindow.theme.downloadItemsBorder
        }
    }
}
