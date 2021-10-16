import QtQuick 2.12
import "../../qt5compat"
import "../BaseElements"

Item
{
    id: root

    property string text: ""

    property bool enableHideButton: false
    property bool hidden: true

    width: parent.width
    height: lbl.implicitHeight

    BaseLabel {
        id: lbl
        width: parent.width
        font.pixelSize: smallSettingsPage ? 18 : 24
        color: appWindow.theme.settingsGroupHeader
        bottomPadding: 10
        text: root.text

        Rectangle {
            visible: !root.enableHideButton || !root.hidden
            color: appWindow.theme.settingsLine
            width: parent.width
            height: 1
            anchors.bottom: parent.bottom
        }
    }

    Rectangle {
        id: hideButton

        visible: root.enableHideButton

        x: lbl.contentWidth + 7
        y: (lbl.contentHeight - height) / 2


        color: "transparent"
        width: 19
        height: 21

        Rectangle {
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            color: "transparent"
            width: 19
            height: 15
            clip: true
            Image {
                source: appWindow.theme.elementsIcons
                sourceSize.width: 93
                sourceSize.height: 456
                x: root.hidden ? 3 : -37
                y: -22
                layer {
                    effect: ColorOverlay {
                        color: appWindow.theme.settingsSubgroupHeader
                    }
                    enabled: true
                }
            }
        }
    }

    MouseArea {
        visible: root.enableHideButton
        enabled: visible
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: {hidden = !hidden}
    }
}


