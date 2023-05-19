import QtQuick 2.0
import QtQuick.Controls 2.4
import "../../qt5compat"
import "../../common"

MenuItem {
        id: menuItem

        visible: true

        height: visible ? undefined : 0
        topPadding: visible ? 1 : 0
        bottomPadding: visible ? 1 : 0
        leftPadding: qtbug.leftPadding(20*appWindow.zoom, 10*appWindow.zoom)
        rightPadding: qtbug.rightPadding(20*appWindow.zoom, 10*appWindow.zoom)

        property bool arrow_down: false
        property bool arrow_up: false
        property bool insideMainMenu: false
        property bool offerIndicator: false

        background: Rectangle {
            color: menuItem.highlighted ? appWindow.theme.menuHighlight : (menuItem.insideMainMenu ? appWindow.theme.insideMainMenuBackground : "transparent")
        }

        arrow: Item {
            visible: menuItem.arrow_down || menuItem.arrow_up
            implicitWidth: 20*appWindow.zoom
            implicitHeight: 20*appWindow.zoom
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter

            Rectangle {
                visible: menuItem.arrow_down
                width: 9*appWindow.zoom
                height: 5*appWindow.zoom
                anchors.centerIn: parent
                clip: true
                color: "transparent"
                Image {
                    source: appWindow.theme.elementsIcons
                    sourceSize.width: 93*appWindow.zoom
                    sourceSize.height: 456*appWindow.zoom
                    x: -20*appWindow.zoom
                    y: -108*appWindow.zoom
                }
            }

            Rectangle {
                visible: menuItem.arrow_up
                width: 9*appWindow.zoom
                height: 5*appWindow.zoom
                anchors.centerIn: parent
                clip: true
                color: "transparent"
                WaSvgImage {
                    source: appWindow.theme.elementsIcons
                    zoom: appWindow.zoom
                    x: -39*appWindow.zoom
                    y: -108*appWindow.zoom
                }
            }
        }

        indicator: Item {
            implicitWidth: 20*appWindow.zoom
            implicitHeight: 20*appWindow.zoom
            anchors.left: parent.left
            anchors.verticalCenter: menuItem.offerIndicator && !menuItem.checkable ? parent.verticalCenter : undefined

            Rectangle {
                visible: menuItem.checkable && menuItem.checked
                width: 12*appWindow.zoom
                height: 10*appWindow.zoom
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottomMargin: 3*appWindow.zoom
                clip: true
                color: "transparent"
                WaSvgImage {
                    source: appWindow.theme.elementsIcons
                    zoom: appWindow.zoom
                    x: 0
                    y: -123*appWindow.zoom
                    layer {
                        effect: ColorOverlay {
                            color: appWindow.theme.foreground
                        }
                        enabled: !menuItem.insideMainMenu
                    }
                }
            }

            Rectangle {
                visible: menuItem.offerIndicator && !menuItem.checkable
                anchors.centerIn: parent
                height: 8*appWindow.zoom
                width: 8*appWindow.zoom
                radius: 4*appWindow.zoom
                color: "#40ca0a"
            }
        }

        contentItem: BaseLabel {
            text: menuItem.text
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            wrapMode: Label.WordWrap
            textFormat: Text.PlainText
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onContainsMouseChanged: parent.highlighted = containsMouse
            cursorShape: parent.enabled ? Qt.PointingHandCursor: Qt.ArrowCursor
            acceptedButtons: Qt.NoButton
        }
}
