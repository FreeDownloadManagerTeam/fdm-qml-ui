import QtQuick 2.0
import QtQuick.Controls 2.4
import "../../qt5compat"
import "../../common"

Menu {
    id: root
    margins: 20*appWindow.zoom

    topPadding: 6*appWindow.zoom
    bottomPadding: 6*appWindow.zoom

    implicitWidth: {
        var result = 0;
        for (var i = 0; i < count; ++i) {
            var item = itemAt(i);
            if (item.contentItem) {
                result = Math.max(item.contentItem.implicitWidth, result);
            }
        }
        return result + 40*appWindow.zoom;
    }

    background: Item {
        RectangularGlow {
            anchors.fill: menuBackground
            color: "black"
            glowRadius: 0
            spread: 0
            cornerRadius: 20*appWindow.zoom
        }
        Rectangle {
            id: menuBackground
            anchors.fill: parent
            color: appWindow.theme.background
            radius: 6*appWindow.zoom
        }
    }

    delegate: MenuItem {
        id: menuItem
        topPadding: 1*appWindow.zoom
        bottomPadding: 1*appWindow.zoom
        leftPadding: qtbug.leftPadding(20*appWindow.zoom, 0)
        rightPadding: qtbug.rightPadding(20*appWindow.zoom, 0)

        background: Rectangle {
            color: menuItem.highlighted ? appWindow.theme.menuHighlight : "transparent"
        }

        arrow: Rectangle {
            x: LayoutMirroring.enabled ? 0 : Math.round(parent.width - width)
            implicitWidth: 20*appWindow.zoom
            implicitHeight: 20*appWindow.zoom
            anchors.verticalCenter: parent.verticalCenter
            visible: menuItem.subMenu
            color: "transparent"
            clip: true
            WaSvgImage {
                source: Qt.resolvedUrl("../../images/desktop/menu_arrow.svg")
                zoom: appWindow.zoom
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                opacity: enabled ? 1 : 0.5
                mirror: LayoutMirroring.enabled
                layer {
                    effect: ColorOverlay {
                        color: appWindow.theme.foreground
                    }
                    enabled: true
                }
            }
        }

        indicator: Rectangle {
            x: LayoutMirroring.enabled ? Math.round(parent.width - width) : 0
            implicitWidth: 20*appWindow.zoom
            implicitHeight: 20*appWindow.zoom
            visible: menuItem.checkable && menuItem.checked
            color: "transparent"
            clip: true
            WaSvgImage {
                source: appWindow.theme.elementsIcons
                zoom: appWindow.zoom
                x: 5*appWindow.zoom
                y: -116*appWindow.zoom
                layer {
                    effect: ColorOverlay {
                        color: appWindow.theme.foreground
                    }
                    enabled: true
                }
            }
        }

        contentItem: BaseLabel {
            text: menuItem.text
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            color: appWindow.theme.foreground
            wrapMode: Label.WordWrap
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: parent.enabled ? Qt.PointingHandCursor: Qt.ArrowCursor
            acceptedButtons: Qt.NoButton
        }
    }
}
