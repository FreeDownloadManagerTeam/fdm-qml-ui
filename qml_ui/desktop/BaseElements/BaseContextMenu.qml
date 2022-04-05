import QtQuick 2.0
import QtQuick.Controls 2.4
import "../../qt5compat"

Menu {
    id: root
    margins: 20

    topPadding: 6
    bottomPadding: 6

    implicitWidth: {
        var result = 0;
        for (var i = 0; i < count; ++i) {
            var item = itemAt(i);
            if (item.contentItem) {
                result = Math.max(item.contentItem.implicitWidth, result);
            }
        }
        return result + 40;
    }

    background: Item {
        RectangularGlow {
            anchors.fill: menuBackground
            color: "black"
            glowRadius: 0
            spread: 0
            cornerRadius: 20
        }
        Rectangle {
            id: menuBackground
            anchors.fill: parent
            color: appWindow.theme.background
            radius: 6
        }
    }

    delegate: MenuItem {
        id: menuItem
        topPadding: 1
        bottomPadding: 1
        leftPadding: 20
        rightPadding: 0

        background: Rectangle {
            color: menuItem.highlighted ? appWindow.theme.menuHighlight : "transparent"
        }

        arrow: Rectangle {
            x: Math.round(parent.width - width)
            implicitWidth: 20
            implicitHeight: 20
            anchors.verticalCenter: parent.verticalCenter
            visible: menuItem.subMenu
            color: "transparent"
            clip: true
            Image {
                source: appWindow.theme.elementsIcons
                sourceSize.width: 93
                sourceSize.height: 456
                x: 7
                y: -189
                opacity: enabled ? 1 : 0.5
                layer {
                    effect: ColorOverlay {
                        color: appWindow.theme.foreground
                    }
                    enabled: true
                }
            }
        }

        indicator: Rectangle {
            x: 0
            implicitWidth: 20
            implicitHeight: 20
            visible: menuItem.checkable && menuItem.checked
            color: "transparent"
            clip: true
            Image {
                source: appWindow.theme.elementsIcons
                sourceSize.width: 93
                sourceSize.height: 456
                x: 5
                y: -116
                layer {
                    effect: ColorOverlay {
                        color: appWindow.theme.foreground
                    }
                    enabled: true
                }
            }
        }

        contentItem: BaseLabel {
            text: menuItem.text
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            color: appWindow.theme.foreground
            wrapMode: Label.WordWrap
//            rightPadding: menuItem.arrow.width
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: parent.enabled ? Qt.PointingHandCursor: Qt.ArrowCursor
            acceptedButtons: Qt.NoButton
        }
    }
}
