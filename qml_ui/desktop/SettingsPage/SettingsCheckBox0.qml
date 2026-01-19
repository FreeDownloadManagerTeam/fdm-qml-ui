import QtQuick
import "../BaseElements"

BaseCheckBox {
    textColor: appWindow.uiver === 1 ?
                   appWindow.theme.settingsItem :
                   appWindow.theme_v2.textColor
    elideText: false
}
