import QtQuick 2.11
import QtQuick.Controls 2.3

Label {
    opacity: enabled ? 1 : (appWindow.uiver === 1 ? 0.5 : appWindow.theme_v2.opacityDisabled)
    font.pixelSize: appWindow.uiver === 1 ?
                        14*appWindow.fontZoom :
                        appWindow.theme_v2.fontSize*appWindow.fontZoom
    font.family: appWindow.uiver === 1 ?
                     (Qt.platform.os === "osx" ? font.family : "Arial") :
                     appWindow.theme_v2.fontFamily
    font.weight: appWindow.uiver === 1 ? 400 : 500
    color: appWindow.uiver === 1 ?
               appWindow.theme.foreground :
               appWindow.theme_v2.textColor
    linkColor: appWindow.uiver === 1 ?
                   appWindow.theme.link :
                   appWindow.theme_v2.primary
    horizontalAlignment: Text.AlignLeft
}
