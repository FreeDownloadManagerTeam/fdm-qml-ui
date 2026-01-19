import QtQuick
import QtQuick.Controls

ToolButton {
    width: 48
    height: 48
    flat: true
    icon.color: appWindow.theme.toolbarTextColor
    icon.width: 20
    icon.height: 20
    opacity: enabled ? 1 : 0.3
}
