import QtQuick 2.0
import QtQuick.Controls 2.3
import "../../qt5compat"

MenuItem {
    id: menuItem

    height: visible ? 30 : 0

    indicator: Item {
        implicitWidth: 30
        implicitHeight: 30

        x: menuItem.width - width - menuItem.rightPadding
        y: menuItem.topPadding + menuItem.availableHeight / 2 - height / 2

        Image {
            id: img
            visible: menuItem.checkable && menuItem.checked
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            anchors.rightMargin: 5
            anchors.bottomMargin: 8
            source: Qt.resolvedUrl("../../images/mobile/check.svg")
            sourceSize.width: 16
            sourceSize.height: 16
            layer {
                effect: ColorOverlay {
                    color: appWindow.theme.sortCheck
                }
                enabled: true
            }
        }
    }

    contentItem: Item {
        Row {
            anchors.verticalCenter: parent.verticalCenter

            spacing: 5

            Label {
                text: menuItem.text
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
                leftPadding: menuItem.enabled ? 16 : 10
                font.pointSize: menuItem.enabled ? 14 : 16
                color: appWindow.theme.foreground
            }
        }
    }
}
