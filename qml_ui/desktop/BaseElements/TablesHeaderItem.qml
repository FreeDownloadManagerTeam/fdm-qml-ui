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
                                             img.width + 6*2*appWindow.zoom

    property int headerMinimumWidth: indicatorElemRealWidth + 16*appWindow.zoom

    property int mouseAcceptedButtons: Qt.LeftButton

    signal clicked(var mouse)

    implicitHeight: 24*appWindow.zoom
    color: "transparent"

    BaseLabel {
        id: lbl
        visible: root.textMode
        text: root.text
        font.bold: false
        font.pixelSize: 13*appWindow.fontZoom
        padding: 6*appWindow.zoom
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        color: appWindow.theme.tableHeaderItem
        width: parent.width - 11*appWindow.zoom
    }

    WaSvgImage
    {
        id: img
        zoom: appWindow.zoom
        visible: !root.textMode
        source: imageSource
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin: 6*zoom
    }

    Item {
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: root.indicatorElemRealWidth
        visible: showSortIndicator
        width: 10*appWindow.zoom
        height: 10*appWindow.zoom
        WaSvgImage {
            zoom: appWindow.zoom
            source: appWindow.theme.elementsIconsRoot + (sortAscendingOrder ? "/arrow_up2.svg" : "/arrow_down2.svg")
            anchors.centerIn: parent
        }
    }

    Rectangle {
        height: parent.height
        width: 1*appWindow.zoom
        anchors.left: parent.left
        color: appWindow.theme.border
    }
    Rectangle {
        width: parent.width
        height: 1*appWindow.zoom
        anchors.bottom: parent.bottom
        color: appWindow.theme.border
    }

    MouseArea {
        anchors.fill: parent
        onClicked: (mouse) => root.clicked(mouse)
        hoverEnabled: true
        acceptedButtons:root.mouseAcceptedButtons

        BaseToolTip {
            text: root.text
            visible: root.textMode && lbl.truncated && parent.containsMouse
        }
    }
}
