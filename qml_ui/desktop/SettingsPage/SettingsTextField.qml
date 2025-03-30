import QtQuick 2.11
import QtQuick.Controls 2.3
import '../BaseElements'

BaseTextField {
    id: root
    implicitHeight: appWindow.uiver === 1 ?
                        25*appWindow.zoom :
                        30*appWindow.zoom
    leftPadding: 8*appWindow.zoom
    rightPadding: 8*appWindow.zoom
    font.pixelSize: appWindow.uiver === 1 ?
                        12*appWindow.fontZoom :
                        appWindow.theme_v2.fontSize*appWindow.fontZoom
    color: appWindow.uiver === 1 ?
               appWindow.theme.settingsItem :
               appWindow.theme_v2.textColor
    background: Rectangle {
        color: appWindow.uiver === 1 ?
                   "transparent" :
                   appWindow.theme_v2.bgColor
        radius: appWindow.uiver === 1 ?
                    5*appWindow.zoom :
                    8*appWindow.zoom
        border.color: appWindow.uiver === 1 ?
                          appWindow.theme.settingsControlBorder :
                          (root.activeFocus ? appWindow.theme_v2.primary : appWindow.theme_v2.editTextBorderColor)
        border.width: 1*appWindow.zoom
    }
}
