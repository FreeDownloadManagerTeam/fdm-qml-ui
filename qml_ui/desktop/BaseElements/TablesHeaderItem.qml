import QtQuick 2.10
import QtQuick.Controls 2.3
import org.freedownloadmanager.fdm 1.0
import "../../common"

Rectangle {
    id: root
    property string text
    property url imageSource
    property int sortBy

    property bool showSortIndicator: false
    property bool sortAscendingOrder: false

    property bool textMode: text.length !== 0

    property var indicatorElemRealWidth: root.textMode ?
                                             lbl.contentWidth + lbl.leftPadding + lbl.rightPadding :
                                             img.width + 6*2

    property int headerMinimumWidth: indicatorElemRealWidth + 16

    signal clicked

    height: 24
    color: "transparent"

    BaseLabel {
        id: lbl
        visible: root.textMode
        text: root.text
        font.bold: false
        font.pixelSize: 13
        padding: 6
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        color: appWindow.theme.tableHeaderItem
        width: parent.width - 11
    }

    WaSvgImage
    {
        id: img
        visible: !root.textMode
        source: imageSource
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin: 6
    }

    Rectangle {
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: root.indicatorElemRealWidth
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
            visible: root.textMode && lbl.truncated && parent.containsMouse
        }
    }
}
