import QtQuick
import QtQuick.Controls

RoundButton {
    id: root
    height: 60
    width: txt.contentWidth + 20 > 60 ? txt.contentWidth + 20 : 60
    radius: 60
    flat: true
    property color textColor: appWindow.theme.foreground

    contentItem: Text {
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter

        id: txt
        text: root.text
        font.pixelSize: 14
        color: textColor
        opacity: root.enabled ? 1 : 0.3

        font.family: "Roboto"
        font.weight: Font.DemiBold
    }
}

