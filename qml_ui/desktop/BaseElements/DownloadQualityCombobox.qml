import QtQuick 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3

ComboBox {
    id: root

    rightPadding: 5
    leftPadding: 5

    property int visibleRowsCount: 5

    model: ListModel {}

    delegate: Rectangle {
        property bool hover: false
        color: hover ? appWindow.theme.menuHighlight : "transparent"
        height: 30
        width: parent.width
        BaseLabel {
            leftPadding: 6
            anchors.verticalCenter: parent.verticalCenter
            text: version
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onEntered: parent.hover = true
            onExited: parent.hover = false
            onClicked: {
                root.currentIndex = index
                root.popup.close();
                downloadTools.selectQuality(index);
            }
        }
    }

    background: Rectangle {
        color: appWindow.theme.background
        border.color: appWindow.theme.border
        border.width: 1
    }

    contentItem: Rectangle {
        color: "transparent"
        BaseLabel {
            anchors.verticalCenter: parent.verticalCenter
            text: root.currentText
        }
    }

    indicator: Rectangle {
        x: root.width - width
        y: root.topPadding + (root.availableHeight - height) / 2
        width: height - 1
        height: root.height
        color: "transparent"
        border.width: 1
        border.color: appWindow.theme.border
        Rectangle {
            width: 9
            height: 8
            color: "transparent"
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            clip: true
            Image {
                source: appWindow.theme.elementsIcons
                sourceSize.width: 93
                sourceSize.height: 456
                x: 0
                y: -448
            }
        }
    }

    popup: Popup {
        y: root.height - 1
        width: root.width
        height: Math.min(visibleRowsCount, downloadTools.versionCount) * 30 + 2
        padding: 1

        background: Rectangle {
            color: appWindow.theme.background
            border.color: appWindow.theme.border
            border.width: 1
        }

        contentItem: Item {
            ListView {
                clip: true
                flickableDirection: Flickable.VerticalFlick
                ScrollBar.vertical: ScrollBar{ visible: downloadTools.versionCount > visibleRowsCount; policy: ScrollBar.AlwaysOn; }
                boundsBehavior: Flickable.StopAtBounds
                anchors.fill: parent
                model: root.model
                currentIndex: root.highlightedIndex
                delegate: root.delegate
            }
        }
    }
}
