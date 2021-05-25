import QtQuick 2.10
import QtQuick.Controls 2.3
import org.freedownloadmanager.fdm 1.0

ToolButton {
    property int value
    property bool selected: App.downloads.model.downloadsStatesFilter == value
    property int underlineWidth: Math.round(parent.width / 3)
    height: parent.height

    contentItem: Text {
        text: parent.text
        font.weight: selected ? Font.DemiBold : Font.Normal
        font.capitalization: Font.AllUppercase
        opacity: selected ? 1.0 : 0.5
        color: appWindow.theme.toolbarTextColor
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }

    onClicked: {
        App.downloads.model.downloadsStatesFilter = value;
    }

    background: Rectangle {
        anchors.fill: parent
        implicitWidth: underlineWidth
        implicitHeight: height
        color: "transparent"

        Rectangle {
            visible: selected
            color: appWindow.theme.toolbarTextColor
            width: Math.round(parent.width * 0.6)
            height: 2
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }
}
