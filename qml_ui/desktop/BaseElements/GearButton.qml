import QtQuick 2.0
import "../../common"
import "../../qt5compat"

Rectangle
{
    id: root

    signal clicked()

    implicitHeight: 26*appWindow.zoom
    implicitWidth: implicitHeight

    readonly property var colorFn: appWindow.theme.isLightTheme ? Qt.darker : Qt.lighter

    color: ma.containsMouse && !ma.pressed ?
               colorFn(appWindow.theme.background, 1.4) :
               colorFn(appWindow.theme.background, 1.1)

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
            effect: ColorOverlay {
                color: appWindow.theme.foreground
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
