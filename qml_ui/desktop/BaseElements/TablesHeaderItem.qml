import QtQuick 2.10
import QtQuick.Controls 2.3
import org.freedownloadmanager.fdm 1.0

Rectangle {
    id: root
    property string text
    property string sortOptionName

    property bool showSortIndicator: false
    property bool sortAscendingOrder: false

    property int headerMinimumWidth: lbl.contentWidth + lbl.leftPadding + lbl.rightPadding + 16

    signal clicked

    height: 24
    color: "transparent"

    BaseLabel {
        id: lbl
        text: root.text
        font.bold: false
        font.pixelSize: 13
        padding: 6
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        color: appWindow.theme.tableHeaderItem
        width: parent.width - 11
    }

    Rectangle {
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: lbl.contentWidth + lbl.leftPadding + lbl.rightPadding
        visible: showSortIndicator
        width: 10
        height: 10
        clip: true
        color: "transparent"
        Image {
            source: appWindow.theme.elementsIcons
            sourceSize.width: 93
            sourceSize.height: 456
            x: sortAscendingOrder ? -39 : -19
            y: -105
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
        hoverEnabled: true

        BaseToolTip {
            text: root.text
            visible: lbl.truncated && parent.containsMouse
        }
    }
}
