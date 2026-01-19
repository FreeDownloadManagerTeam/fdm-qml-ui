import QtQuick
import QtQuick.Effects
import "../../../common"

WaSvgImage
{
    readonly property color supposedImageColor: enabled ?
                                                    appWindow.theme_v2.bg1000 :
                                                    appWindow.theme_v2.bg600
    property bool applyImageColor: true
    property color imageColor: supposedImageColor
    zoom: appWindow.zoom
    layer {
        enabled: applyImageColor
        effect: MultiEffect {colorization: 1.0; colorizationColor: imageColor}
    }
}
