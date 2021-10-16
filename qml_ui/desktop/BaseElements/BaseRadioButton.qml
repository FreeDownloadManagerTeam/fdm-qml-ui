import QtQuick 2.11
import QtQuick.Controls 2.4
import "../../qt5compat"

RadioButton {
    id: control
    property string textColor

    padding: 0

    indicator: Rectangle {
        color: "transparent"
        anchors.verticalCenter: parent.verticalCenter
        x: 6
        width: 12
        height: 12
        clip: true

        Image {
            x: control.checked ? -20 : 0
            y: -64
            source: appWindow.theme.checkboxIcons
            sourceSize.width: 212
            sourceSize.height: 76
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
        leftPadding: 27
        text: parent.text
        color: parent.textColor ? parent.textColor : color
    }
}
