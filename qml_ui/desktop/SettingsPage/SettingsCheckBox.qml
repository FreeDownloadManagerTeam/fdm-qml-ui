import QtQuick 2.0
import "../BaseElements"

BaseCheckBox {
    anchors.left: parent.left
    anchors.leftMargin: 12*appWindow.zoom
    textColor: appWindow.theme.settingsItem
    elideText: false
}
