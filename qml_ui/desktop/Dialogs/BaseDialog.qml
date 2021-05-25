import QtQuick 2.0
import QtQuick.Controls 2.3
import QtGraphicalEffects 1.0

Dialog {
    id: baseDialog
    modal: false
    dim: false
    closePolicy: Popup.NoAutoClose

    x: Math.round((parent.width - width) / 2)
    y: Math.round((parent.height - baseDialog.height) / 2)

    background: Rectangle {
        anchors.fill: baseDialog.contentItem
        color: "transparent"

        RectangularGlow {
            anchors.fill: parent
            color: appWindow.theme.dialogGlow
            glowRadius: 4
            spread: 0
            cornerRadius: 4
        }

        Rectangle {
            anchors.fill: parent
            color: appWindow.theme.dialogBackground
        }
    }
}
