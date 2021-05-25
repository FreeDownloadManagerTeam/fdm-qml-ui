import QtQuick 2.10
import "../BaseElements"

BaseLabel {
    width: parent.width
    font.pixelSize: smallSettingsPage ? 18 : 24
    color: appWindow.theme.settingsGroupHeader
    bottomPadding: 10

    Rectangle {
        color: appWindow.theme.settingsLine
        width: parent.width
        height: 1
        anchors.bottom: parent.bottom
//        anchors.bottomMargin: 18
    }
}
