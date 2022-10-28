import QtQuick 2.12
import "../../common"
import "../../qt5compat"

CustomButton
{
    id: root

    implicitWidth: Math.max(37*appWindow.zoom, img.preferredWidth + 2*5*appWindow.zoom)
    implicitHeight: Math.max(30*appWindow.zoom, img.preferredHeight + 2*5*appWindow.zoom)

    clip: true

    WaSvgImage
    {
        id: img
        source: Qt.resolvedUrl("../../images/desktop/pick_file.svg")
        zoom: appWindow.zoom
        anchors.centerIn: parent

        layer {
            effect: ColorOverlay {
                color: root.isPressed ? root.secondaryTextColor : root.primaryTextColor
            }
            enabled: true
        }
    }
}
