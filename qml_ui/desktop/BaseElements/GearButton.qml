import QtQuick
import QtQuick.Effects
import "../../common"

Rectangle
{
    id: root

    signal clicked()

    implicitHeight: 26*appWindow.zoom
    implicitWidth: implicitHeight

    function colorFn(clr, factor) {
        return appWindow.theme.isLightTheme ?
                    Qt.darker(clr, factor) :
                    Qt.lighter(clr, factor);
    }

    color: ma.containsMouse && !ma.pressed ?
               colorFn(appWindow.uiver === 1 ? appWindow.theme.background : appWindow.theme_v2.bgColor, 1.4) :
               colorFn(appWindow.uiver === 1 ? appWindow.theme.background : appWindow.theme_v2.bgColor, 1.1)

    radius: 4*appWindow.zoom

    WaSvgImage
    {
        id: img
        source: Qt.resolvedUrl("../../images/gear.svg")
        zoom: appWindow.zoom

        height: root.height - 6*appWindow.zoom
        width: height

        anchors.centerIn: parent

        layer {
            effect: MultiEffect {
                colorization: 1.0
                colorizationColor: appWindow.uiver === 1 ? appWindow.theme.foreground : appWindow.theme_v2.textColor
            }
            enabled: true
        }
    }

    MouseArea
    {
        id: ma
        hoverEnabled: true
        anchors.fill: parent
        onClicked: root.clicked()
    }
}
