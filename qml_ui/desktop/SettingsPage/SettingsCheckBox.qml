import QtQuick 2.0
import "../BaseElements"

BaseCheckBox {
    anchors.left: parent.left
    anchors.leftMargin: 12*appWindow.zoom
    textColor: appWindow.uiver === 1 ?
                   appWindow.theme.settingsItem :
                   appWindow.theme_v2.textColor
    elideText: false
}
