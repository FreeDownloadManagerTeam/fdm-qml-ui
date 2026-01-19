import QtQuick
import QtQuick.Controls.Material

Rectangle {
    color: appWindow.theme.toolbarBackground
    Material.foreground: appWindow.theme.toolbarTextColor
    width: parent.width
    height: 44
}
