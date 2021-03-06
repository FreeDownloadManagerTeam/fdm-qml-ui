import QtQuick 2.0
import QtQuick.Controls 2.3
import "../../qt5compat"

ComboBox {
    id: root

    rightPadding: 5
    leftPadding: 5
    implicitWidth: 100
    implicitHeight: 30

    editable: true

    property int visibleRowsCount: 5
    signal textChanged(string str)

    model: ["00:00", "01:00", "02:00", "03:00", "04:00", "05:00", "06:00", "07:00", "08:00", "09:00", "10:00", "11:00", "12:00",
            "13:00", "14:00", "15:00", "16:00", "17:00", "18:00", "19:00", "20:00", "21:00", "22:00", "23:00", "23:59"]

    delegate: Rectangle {
        property bool hover: false
        color: hover ? appWindow.theme.menuHighlight : "transparent"
        height: 30
        width: 100

        BaseLabel {
            leftPadding: 6
            anchors.verticalCenter: parent.verticalCenter
            text: modelData
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onEntered: parent.hover = true
            onExited: parent.hover = false
            onClicked: {
                root.currentIndex = index;
                root.textChanged(currentText);
                root.popup.close();
            }
        }
    }

    background: Rectangle {
        color: appWindow.theme.background
        border.color: appWindow.theme.border
        border.width: 1
    }

    contentItem: TextField {
        text: root.editText
        font.pixelSize: 14
        rightPadding: 30
        selectByMouse: true
        background: Rectangle {
            color: "transparent"
            border.color: "transparent"
        }

        inputMethodHints: Qt.ImhTime
        validator: QtRegExpValidator { regExp: /^(\d{0,2})([:]\d{0,2})?$/ }
        placeholderText: "00:00"
        onActiveFocusChanged: {
            if (!activeFocus) {
                root.textChanged(text)
            }
        }
        onAccepted: root.textChanged(text)

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
        width: root.width
        height: Math.min(visibleRowsCount, root.model.length) * 30 + 2
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
                ScrollBar.vertical: ScrollBar{ visible: root.model.length > visibleRowsCount; policy: ScrollBar.AlwaysOn; }
                boundsBehavior: Flickable.StopAtBounds
                anchors.fill: parent
                model: root.model
                currentIndex: root.highlightedIndex
                delegate: root.delegate
            }
        }
    }
}
