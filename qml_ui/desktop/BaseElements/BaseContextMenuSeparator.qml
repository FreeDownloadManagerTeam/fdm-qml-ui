import QtQuick 2.0
import QtQuick.Controls 2.4

MenuSeparator {

    contentItem: Rectangle {
        visible: true
        implicitHeight: visible ? 7*appWindow.zoom : 0
        color: "transparent"

        Rectangle {
            width: parent.width
            anchors.verticalCenter: parent.verticalCenter
            implicitHeight: 1*appWindow.zoom
            color: appWindow.uiver === 1 ?
                       appWindow.theme.downloadItemsBorder :
                       appWindow.theme_v2.bg400
        }
    }
}
