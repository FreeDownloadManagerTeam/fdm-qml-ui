import QtQuick 2.0
import QtQuick.Controls 2.3
import "../../qt5compat"
import "../../common"

ComboBox {
    id: root

    rightPadding: 5*appWindow.zoom
    leftPadding: 5*appWindow.zoom
    implicitWidth: 100*appWindow.zoom
    implicitHeight: 30*appWindow.zoom

    editable: true

    property int visibleRowsCount: 5
    signal textChanged(string str)

    model: ["00:00", "01:00", "02:00", "03:00", "04:00", "05:00", "06:00", "07:00", "08:00", "09:00", "10:00", "11:00", "12:00",
            "13:00", "14:00", "15:00", "16:00", "17:00", "18:00", "19:00", "20:00", "21:00", "22:00", "23:00", "23:59"]

    delegate: Rectangle {
        property bool hover: false
        color: hover ? appWindow.theme.menuHighlight : "transparent"
        height: 30*appWindow.zoom
        width: 100*appWindow.zoom

        BaseLabel {
            anchors.left: parent.left
            leftPadding: qtbug.leftPadding(5*appWindow.zoom, 0)
            rightPadding: qtbug.rightPadding(5*appWindow.zoom, 0)
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
        border.width: 1*appWindow.zoom
    }

    contentItem: BaseTextField {
        text: root.editText
        font.pixelSize: 14*appWindow.fontZoom
        leftPadding: qtbug.leftPadding(0, 30*appWindow.zoom)
        rightPadding: qtbug.rightPadding(0, 30*appWindow.zoom)
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
        x: LayoutMirroring.enabled ? 0 : root.width - width
        y: root.topPadding + (root.availableHeight - height) / 2
        width: height - 1*appWindow.zoom
        height: root.height
        color: "transparent"
        border.width: 1*appWindow.zoom
        border.color: appWindow.theme.border
        Rectangle {
            width: 9*appWindow.zoom
            height: 8*appWindow.zoom
            color: "transparent"
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            clip: true
            WaSvgImage {
                source: appWindow.theme.elementsIcons
                zoom: appWindow.zoom
                x: 0
                y: -448*zoom
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
        height: Math.min(visibleRowsCount, root.model.length) * 30*appWindow.zoom + 2*appWindow.zoom
        padding: 1*appWindow.zoom

        background: Rectangle {
            color: appWindow.theme.background
            border.color: appWindow.theme.border
            border.width: 1*appWindow.zoom
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
