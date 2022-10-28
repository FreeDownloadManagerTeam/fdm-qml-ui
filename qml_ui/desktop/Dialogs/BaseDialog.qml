import QtQuick 2.0
import QtQuick.Controls 2.3
import "../../qt5compat"

Dialog {
    id: baseDialog
    modal: false
    dim: false
    closePolicy: Popup.NoAutoClose

    x: Math.round((parent.width - width) / 2)
    y: Math.round((parent.height - height) / 2)

    background: Rectangle {
        anchors.fill: baseDialog.contentItem
        color: "transparent"

        RectangularGlow {
            anchors.fill: parent
            color: appWindow.theme.dialogGlow
            glowRadius: 4*appWindow.zoom
            spread: 0
            cornerRadius: 4*appWindow.zoom
        }

        Rectangle {
            anchors.fill: parent
            color: appWindow.theme.dialogBackground
        }
    }
}
