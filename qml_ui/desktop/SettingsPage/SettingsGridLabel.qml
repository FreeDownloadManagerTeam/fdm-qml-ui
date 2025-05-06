import QtQuick 2.0
import "../BaseElements"

BaseLabel {
    color: appWindow.uiver === 1 ?
               appWindow.theme.settingsItem :
               appWindow.theme_v2.textColor
}
