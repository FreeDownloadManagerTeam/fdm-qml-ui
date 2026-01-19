import QtQuick
import "../BaseElements"

BaseLabel {
    color: appWindow.uiver === 1 ?
               appWindow.theme.settingsItem :
               appWindow.theme_v2.textColor
}
