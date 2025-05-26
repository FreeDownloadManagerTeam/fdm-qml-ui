import QtQuick 2.0
import "../BaseElements"

BaseCheckBox {
    textColor: appWindow.uiver === 1 ?
                   appWindow.theme.settingsItem :
                   appWindow.theme_v2.textColor
    elideText: false
}
