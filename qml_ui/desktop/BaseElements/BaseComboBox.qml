import QtQuick 2.12
import QtQuick.Controls 2.12
import "../BaseElements"
import "../../common"

ComboBox {
    id: root

    BaseLabel {
        id: l
        visible: false
        font.pixelSize: 12*appWindow.fontZoom
    }

    FontMetrics {
        id: fm
        font: l.font
    }

    implicitHeight: fm.height + 10*appWindow.zoom

    implicitWidth: {
        let h = 0;
        for (let i = 0; i < model.length; ++i)
            h = Math.max(h, fm.advanceWidth(model[i].text));
        return h + 40*appWindow.zoom;
    }

    delegate: Rectangle {
        property bool hover: false
        color: hover ? appWindow.theme.menuHighlight : "transparent"
        height: 18*appWindow.zoom
        width: root.width

        BaseLabel {
            leftPadding: 6*appWindow.zoom
            anchors.verticalCenter: parent.verticalCenter
            font: l.font
            color: appWindow.theme.settingsItem
            text: modelData.text
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onEntered: parent.hover = true
            onExited: parent.hover = false
            onClicked: {
                root.popup.close();
                root.activated(root.currentIndex = index);
            }
        }
    }

    background: Rectangle {
        color: "transparent"
        radius: 5*appWindow.zoom
        border.color: appWindow.theme.settingsControlBorder
        border.width: 1*appWindow.zoom
    }

    contentItem: Rectangle {
        color: "transparent"
        BaseLabel {
            leftPadding: 2*appWindow.zoom
            anchors.verticalCenter: parent.verticalCenter
            font: l.font
            color: appWindow.theme.settingsItem
            text: root.model[currentIndex].text
        }
    }

    indicator: Rectangle {
        x: root.width - width
        y: root.topPadding + (root.availableHeight - height) / 2
        width: height - 1*appWindow.zoom
        height: root.height
        color: "transparent"
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
    }

    popup: Popup {
        y: root.height
        width: root.width
        height: 18*appWindow.zoom * root.model.length + 2*appWindow.zoom
        padding: 1*appWindow.zoom

        background: Rectangle {
            color: appWindow.theme.background
            border.color: appWindow.theme.settingsControlBorder
            border.width: 1*appWindow.zoom
        }

        contentItem: Item {
            ListView {
                clip: true
                anchors.fill: parent
                model: root.model
                currentIndex: root.highlightedIndex
                delegate: root.delegate
                flickableDirection: Flickable.VerticalFlick
                boundsBehavior: Flickable.StopAtBounds
            }
        }
    }
}
