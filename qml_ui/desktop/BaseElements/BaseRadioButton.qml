import QtQuick 2.11
import QtQuick.Controls 2.4
import "../../qt5compat"
import "../../common"

RadioButton {
    id: control
    property string textColor

    padding: 0

    indicator: Rectangle {
        color: "transparent"
        anchors.verticalCenter: parent.verticalCenter
        x: LayoutMirroring.enabled ? control.width - width - 6*appWindow.zoom : 6*appWindow.zoom
        width: 12*appWindow.zoom
        height: 12*appWindow.zoom
        clip: true

        WaSvgImage {
            zoom: appWindow.zoom
            x: (control.checked ? -20 : 0)*zoom
            y: -64*zoom
            source: appWindow.theme.checkboxIcons
            layer {
                effect: ColorOverlay {
                    color: appWindow.theme.inactiveControl
                }
                enabled: !appWindow.active
            }
        }
    }

    contentItem: BaseLabel {
        anchors.left: parent.left
        anchors.verticalCenter: control.verticalCenter
        leftPadding: qtbug.leftPadding(27*appWindow.zoom, 0)
        rightPadding: qtbug.rightPadding(27*appWindow.zoom, 0)
        text: parent.text
        color: parent.textColor ? parent.textColor : appWindow.theme.foreground
    }
}
