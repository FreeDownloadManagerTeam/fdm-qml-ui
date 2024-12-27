import QtQuick 2.0
import QtQuick.Controls 2.4
import "../../qt5compat"
import "../../common"
import "V2"

MenuItem {
        id: menuItem

        visible: true

        height: visible ? undefined : 0
        topPadding: ((visible && appWindow.uiver === 1) ? 1 : 2)*appWindow.zoom
        bottomPadding: ((visible && appWindow.uiver === 1) ? 1 : 2)*appWindow.zoom
        leftPadding: appWindow.uiver === 1 ? qtbug.leftPadding(20*appWindow.zoom, 10*appWindow.zoom) :
                                             qtbug.leftPadding(16*appWindow.zoom, 12*appWindow.zoom)
        rightPadding: appWindow.uiver === 1 ? qtbug.rightPadding(20*appWindow.zoom, 10*appWindow.zoom) :
                                              qtbug.leftPadding(16*appWindow.zoom, 12*appWindow.zoom)

        property bool arrow_down: false
        property bool arrow_up: false
        property bool insideMainMenu: false
        property bool offerIndicator: false

        background: Rectangle {
            color: appWindow.uiver === 1 ?
                       (menuItem.highlighted ? appWindow.theme.menuHighlight : (menuItem.insideMainMenu ? appWindow.theme.insideMainMenuBackground : "transparent")) :
                       (menuItem.highlighted ? appWindow.theme_v2.hightlightBgColor : "transparent")
            radius: appWindow.uiver === 1 ? 0 : 4*appWindow.zoom
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

        indicator: Item {
            x: LayoutMirroring.enabled ? Math.round(parent.width - width) : 0
            implicitWidth: 20*appWindow.zoom
            implicitHeight: 20*appWindow.zoom
            visible: menuItem.checkable && menuItem.checked
            WaSvgImage {
                source: appWindow.theme.elementsIconsRoot + "/check_mark.svg"
                zoom: appWindow.zoom
                anchors.horizontalCenter: parent.horizontalCenter
                y: (parent.height - height) / 2 + 1*zoom
                layer {
                    effect: ColorOverlay {
                        color: appWindow.theme.foreground
                    }
                    enabled: true
                }
            }
        }

        Component {
            id: contentItem_v1
            BaseLabel {
                text: menuItem.text
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
                wrapMode: Label.WordWrap
                textFormat: Text.PlainText
            }
        }

        Component {
            id: contentItem_v2
            BaseText_V2 {
                text: menuItem.text
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
                wrapMode: Label.WordWrap
                textFormat: Text.PlainText
            }
        }

        contentItem: Loader {
            sourceComponent: appWindow.uiver === 1 ? contentItem_v1 : contentItem_v2
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onContainsMouseChanged: parent.highlighted = containsMouse
            cursorShape: parent.enabled ? Qt.PointingHandCursor: Qt.ArrowCursor
            acceptedButtons: Qt.NoButton
        }
}
