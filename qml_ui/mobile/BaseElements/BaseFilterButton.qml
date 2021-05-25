import QtQuick 2.10
import QtQuick.Controls 2.3

ToolButton {
    property int value
    property bool selected
    height: parent.height
    padding: 0

    contentItem: Text {
        text: parent.text
        font.weight: selected ? Font.DemiBold : Font.Normal
        font.capitalization: Font.AllUppercase
        opacity: selected ? 1.0 : 0.5
        color: appWindow.theme.toolbarTextColor
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

    background: Rectangle {
        anchors.fill: parent
        implicitWidth: contentItem.contentWidth
        implicitHeight: height
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
