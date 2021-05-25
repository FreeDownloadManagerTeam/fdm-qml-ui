import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3

ComboBox {
    id: root

    rightPadding: 5
    leftPadding: 5
    implicitHeight: 30

    editable: true

    property int popupWidth: 120
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
            text: folder
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onEntered: parent.hover = true
            onExited: parent.hover = false
            onClicked: {
                root.currentIndex = index;
                root.editText = folder;
                root.popup.close();
            }
        }
    }

    background: Rectangle {
        color: appWindow.theme.background
        border.color: appWindow.theme.border
        border.width: 1
    }

    contentItem: BaseTextField {
        text: root.editText
        rightPadding: 30
        background: Rectangle {
            color: "transparent"
            border.color: "transparent"
        }
    }

    indicator: Rectangle {
        z: 1
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

        MouseArea {
            propagateComposedEvents: false
            height: parent.height
            width: parent.width
            cursorShape: Qt.ArrowCursor
            onClicked: {
                if (root.popup.opened) {
                    root.popup.close();
                } else {
                    root.popup.open();
                }
            }
        }
    }

    popup: Popup {
        y: root.height - 1
        width: Math.max(popupWidth, root.width)
        height: Math.min(visibleRowsCount, root.model.count) * 30 + 2
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
                ScrollBar.vertical: ScrollBar{ visible: root.model.count > visibleRowsCount; policy: ScrollBar.AlwaysOn; }
                boundsBehavior: Flickable.StopAtBounds
                anchors.fill: parent
                model: root.model
                currentIndex: root.highlightedIndex
                delegate: root.delegate
            }
        }
    }

    onModelChanged: setPopupWidth()

    function setPopupWidth() {
        var maxVal = 0;
        var currentVal = 0;
        for (var index in model) {
            currentVal = checkTextSize(model.get(index).folder);
            maxVal = maxVal < currentVal ? currentVal : maxVal;
        }
        popupWidth = maxVal + 20;
    }

    function checkTextSize(text)
    {
        textMetrics.text = text;
        return textMetrics.width;
    }

    TextMetrics {
        id: textMetrics
        font.pixelSize: 12
        font.family: Qt.platform.os === "osx" ? font.family : "Arial"
    }
}
