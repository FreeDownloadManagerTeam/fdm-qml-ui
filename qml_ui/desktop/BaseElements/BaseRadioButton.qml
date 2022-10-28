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
        x: 6*appWindow.zoom
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
        anchors.verticalCenter: control.verticalCenter
        leftPadding: 27*appWindow.zoom
        text: parent.text
        color: parent.textColor ? parent.textColor : color
    }
}
