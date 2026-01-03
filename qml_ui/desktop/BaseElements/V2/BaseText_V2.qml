import QtQuick

Text
{
    opacity: enabled ? 1 : appWindow.theme_v2.opacityDisabled
    color: appWindow.theme_v2.textColor
    font.family: appWindow.theme_v2.fontFamily
    font.pixelSize: appWindow.theme_v2.fontSize*appWindow.fontZoom
    font.weight: appWindow.theme_v2.fontWeight
}
