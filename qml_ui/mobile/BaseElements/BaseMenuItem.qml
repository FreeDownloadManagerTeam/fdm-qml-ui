import QtQuick 2.0
import QtQuick.Controls 2.3
import "../../qt5compat"

MenuItem {
    id: menuItem

    width: parent ? parent.width : undefined
    height: visible ? contentItem.lineCount * 20 + 10 : 0

    indicator: Item {
        implicitWidth: 30
        implicitHeight: 30

        Image {
            id: img
            visible: menuItem.checkable && menuItem.checked
            sourceSize.width: 16
            sourceSize.height: 16
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.leftMargin: 5
            anchors.bottomMargin: 7
            source: Qt.resolvedUrl("../../images/mobile/check.svg")
            layer {
                effect: ColorOverlay {
                    color: appWindow.theme.sortCheck
                }
                enabled: true
            }
        }
    }

    contentItem: Label {
        text: menuItem.text
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        leftPadding: 10
        font.pointSize: 16
        color: appWindow.theme.foreground
        opacity: menuItem.enabled ? 1 : 0.4
        width: parent.width
        wrapMode: Text.WordWrap
    }
}
