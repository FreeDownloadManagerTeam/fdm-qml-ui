import QtQuick
import QtQuick.Controls.Material

Rectangle {
    height: 63
    width: parent.width
    Material.foreground: appWindow.theme.toolbarTextColor
    color: appWindow.theme.primary
}
