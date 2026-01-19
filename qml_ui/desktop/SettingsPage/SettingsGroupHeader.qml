import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import "../BaseElements"
import "../../common"

Item
{
    id: root

    property string text: ""

    property bool enableHideButton: false
    property bool hidden: false

    width: parent.width

    implicitWidth: rootContent.implicitWidth
    implicitHeight: rootContent.implicitHeight

    RowLayout
    {
        id: rootContent

        anchors.fill: parent

        spacing: 7*appWindow.zoom

        BaseLabel {
            id: lbl
            Layout.fillWidth: true
            font.pixelSize: appWindow.uiver === 1 ?
                                (smallSettingsPage ? 18 : 24)*appWindow.fontZoom :
                                20*appWindow.fontZoom
            color: appWindow.uiver === 1 ?
                       appWindow.theme.settingsGroupHeader :
                       appWindow.theme_v2.textColor
            bottomPadding: 10*appWindow.zoom
            text: root.text

            Rectangle {
                visible: appWindow.uiver === 1 && (!root.enableHideButton || !root.hidden)
                color: appWindow.theme.settingsLine
                width: parent.width
                height: 1*appWindow.zoom
                anchors.bottom: parent.bottom
            }
        }

        Item {
            id: hideButton

            visible: root.enableHideButton

            Layout.alignment: Qt.AlignVCenter

            implicitWidth: 19*appWindow.zoom
            implicitHeight: 21*appWindow.zoom

            Item {
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                width: 19*appWindow.zoom
                height: 15*appWindow.zoom
                WaSvgImage {
                    source: appWindow.theme.elementsIconsRoot+(root.hidden ? "/arrow_down.svg" : "/arrow_up.svg")
                    zoom: appWindow.zoom
                    anchors.centerIn: parent
                    layer {
                        effect: MultiEffect {
                            colorization: 1.0
                            colorizationColor: appWindow.uiver === 1 ? appWindow.theme.settingsSubgroupHeader : appWindow.theme_v2.settingsSubgroupHeader
                        }
                        enabled: true
                    }
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


