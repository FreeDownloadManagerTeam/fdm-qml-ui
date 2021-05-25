import QtQuick 2.0
import QtQuick.Controls 2.4
import QtGraphicalEffects 1.0

MenuItem {
        id: menuItem

        visible: true

        height: visible ? undefined : 0
        topPadding: visible ? 1 : 0
        bottomPadding: visible ? 1 : 0
        leftPadding: 20
        rightPadding: 0

        property bool arrow_down: false
        property bool arrow_up: false
        property bool insideMainMenu: false
        property bool offerIndicator: false

        background: Rectangle {
            color: menuItem.highlighted ? appWindow.theme.menuHighlight : (menuItem.insideMainMenu ? appWindow.theme.insideMainMenuBackground : "transparent")
        }

        arrow: Item {
            visible: menuItem.arrow_down || menuItem.arrow_up
            implicitWidth: 20
            implicitHeight: 20
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter

            Rectangle {
                visible: menuItem.arrow_down
                width: 9
                height: 5
                anchors.centerIn: parent
                clip: true
                color: "transparent"
                Image {
                    source: appWindow.theme.elementsIcons
                    sourceSize.width: 93
                    sourceSize.height: 456
                    x: -20
                    y: -108
                }
            }

            Rectangle {
                visible: menuItem.arrow_up
                width: 9
                height: 5
                anchors.centerIn: parent
                clip: true
                color: "transparent"
                Image {
                    source: appWindow.theme.elementsIcons
                    sourceSize.width: 93
                    sourceSize.height: 456
                    x: -39
                    y: -108
                }
            }
        }

        indicator: Item {
            implicitWidth: 20
            implicitHeight: 20
            anchors.verticalCenter: menuItem.offerIndicator && !menuItem.checkable ? parent.verticalCenter : undefined

            Rectangle {
                visible: menuItem.checkable && menuItem.checked
                width: 12
                height: 10
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottomMargin: 3
                clip: true
                color: "transparent"
                Image {
                    source: appWindow.theme.elementsIcons
                    sourceSize.width: 93
                    sourceSize.height: 456
                    x: 0
                    y: -123
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
                height: 8
                width: 8
                radius: 4
                color: "#40ca0a"
            }
        }

        contentItem: BaseLabel {
            text: menuItem.text
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            wrapMode: Label.WordWrap
//            rightPadding: menuItem.arrow.width
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
