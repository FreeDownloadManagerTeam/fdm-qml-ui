import QtQuick 2.10
import QtQuick.Controls 2.3
import "../../qt5compat"

Rectangle {
    id: root
    property string text
    property int sortBy

    property bool showSortIndicator: false
    property bool sortAscendingOrder: false

    signal clicked

    height: appWindow.smallScreen ? 48 : 24
    color: "transparent"

    BaseLabel {
        id: title
        anchors.left: parent.left
        text: root.text
        font.bold: false
        font.pixelSize: 13
        padding: 6
        leftPadding: qtbug.leftPadding(9, 0)
        rightPadding: qtbug.rightPadding(9, 0)
        wrapMode: Label.Wrap
        width: parent.width - 13
        anchors.verticalCenter: parent.verticalCenter
    }

    Rectangle {
        anchors.left: parent.left
        anchors.leftMargin: title.contentWidth + qtbug.getLeftPadding(title) + 5
        anchors.verticalCenter: parent.verticalCenter
        visible: showSortIndicator
        width: 7
        height: 7
        clip: true
        color: "transparent"
        Image {
            id: img
            source: sortAscendingOrder ? Qt.resolvedUrl("../../images/mobile/flag_down.svg") : Qt.resolvedUrl("../../images/mobile/flag_up.svg")
            sourceSize.width: 7
            sourceSize.height: 7
            anchors.centerIn: parent
            layer {
                effect: ColorOverlay {
                    color: appWindow.theme.foreground
                }
                enabled: true
            }
        }
    }

    Rectangle {
        height: parent.height
        width: 1
        anchors.left: parent.left
        color: appWindow.theme.border
    }
    Rectangle {
        width: parent.width
        height: 1
        anchors.bottom: parent.bottom
        color: appWindow.theme.border
    }

    MouseArea {
        anchors.fill: parent
        onClicked: root.clicked()
    }
}
