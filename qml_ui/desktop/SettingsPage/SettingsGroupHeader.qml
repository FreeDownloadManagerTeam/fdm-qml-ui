import QtQuick 2.12
import "../../qt5compat"
import "../BaseElements"
import "../../common"

Item
{
    id: root

    property string text: ""

    property bool enableHideButton: false
    property bool hidden: false

    width: parent.width
    height: lbl.implicitHeight

    BaseLabel {
        id: lbl
        width: parent.width
        font.pixelSize: (smallSettingsPage ? 18 : 24)*appWindow.fontZoom
        color: appWindow.theme.settingsGroupHeader
        bottomPadding: 10*appWindow.zoom
        text: root.text

        Rectangle {
            visible: !root.enableHideButton || !root.hidden
            color: appWindow.theme.settingsLine
            width: parent.width
            height: 1*appWindow.zoom
            anchors.bottom: parent.bottom
        }
    }

    Rectangle {
        id: hideButton

        visible: root.enableHideButton

        x: lbl.contentWidth + 7*appWindow.zoom
        y: (lbl.contentHeight - height) / 2


        color: "transparent"
        width: 19*appWindow.zoom
        height: 21*appWindow.zoom

        Rectangle {
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            color: "transparent"
            width: 19*appWindow.zoom
            height: 15*appWindow.zoom
            clip: true
            WaSvgImage {
                source: appWindow.theme.elementsIcons
                zoom: appWindow.zoom
                x: (root.hidden ? 3 : -37)*zoom
                y: -22*zoom
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


