import QtQuick
import QtQuick.Controls

ToolButton {
    property int value
    property bool selected
    height: parent.height
    padding: 0

    contentItem: Text {
        text: parent.text
        font.weight: selected ? Font.DemiBold : Font.Normal
        font.pixelSize: 14
        font.capitalization: Font.AllUppercase
        opacity: selected ? 1.0 : 0.5
        color: appWindow.theme.toolbarTextColor
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

    background: Rectangle {
        anchors.fill: parent
        color: "transparent"

        Rectangle {
            visible: selected
            color: appWindow.theme.toolbarTextColor
            width: parent.width
            height: 2
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }
}
