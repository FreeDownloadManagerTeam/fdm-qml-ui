import QtQuick
//MultiEffect can be used instead of ColorOverlay; however it's not supported by Qt 6.4.3 which is used at the moment
//Warning: MultiEffect requires SVG image to be in white color OR "brightness: 1.0" should be applied too
// for its colorization effect to work properly.
// https://forum.qt.io/topic/144070/qt6-color-svg-using-multieffect
//import QtQuick.Effects
import Qt5Compat.GraphicalEffects
import "../../../common"

WaSvgImage
{
    readonly property color supposedImageColor: enabled ?
                                                    appWindow.theme_v2.bg1000 :
                                                    appWindow.theme_v2.bg600
    property bool applyImageColor: true
    property color imageColor: supposedImageColor
    zoom: appWindow.zoom
    layer.effect: ColorOverlay { color: imageColor }
    //layer.effect: MultiEffect {colorization: 1.0; colorizationColor: imageColor}
    layer.enabled: applyImageColor
}
