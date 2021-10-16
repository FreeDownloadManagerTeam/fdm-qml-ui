import QtQuick 2.11
import QtQuick.Controls 2.3
import '../BaseElements'

BaseTextField {
    implicitHeight: 25
    leftPadding: 8
    rightPadding: 8
    font.pixelSize: 12
    color: appWindow.theme.settingsItem
    background: Rectangle {
        color: "transparent"
        radius: 5
        border.color: appWindow.theme.settingsControlBorder
        border.width: 1
    }
}
