import QtQuick 2.11
import QtQuick.Controls 2.3
import '../BaseElements'

BaseTextField {
    implicitHeight: 25*appWindow.zoom
    leftPadding: 8*appWindow.zoom
    rightPadding: 8*appWindow.zoom
    font.pixelSize: 12*appWindow.fontZoom
    color: appWindow.theme.settingsItem
    background: Rectangle {
        color: "transparent"
        radius: 5*appWindow.zoom
        border.color: appWindow.theme.settingsControlBorder
        border.width: 1*appWindow.zoom
    }
}
