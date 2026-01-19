import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import "../../common"
import "V2"

MenuItem {
        id: menuItem

        property bool showThreeDotsBtn: false
        signal threeDotsClicked()
        readonly property var threeDotsBtn: threeDotsButton
        property color showRectWithColor: "transparent"
        property int overrideRightPadding: 0
        property bool externalLink: false

        visible: true

        height: visible ? undefined : 0
        topPadding: ((visible && appWindow.uiver === 1) ? 1 : 2)*appWindow.zoom
        bottomPadding: ((visible && appWindow.uiver === 1) ? 1 : 2)*appWindow.zoom
        leftPadding: appWindow.uiver === 1 ? qtbug.leftPadding(20*appWindow.zoom, overrideRightPadding ? overrideRightPadding : 10*appWindow.zoom) :
                                             qtbug.leftPadding(20*appWindow.zoom, overrideRightPadding ? overrideRightPadding : 12*appWindow.zoom)
        rightPadding: appWindow.uiver === 1 ? qtbug.rightPadding(20*appWindow.zoom, overrideRightPadding ? overrideRightPadding : 10*appWindow.zoom) :
                                              qtbug.rightPadding(20*appWindow.zoom, overrideRightPadding ? overrideRightPadding : 12*appWindow.zoom)

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
                    effect: MultiEffect {
                        colorization: 1.0
                        colorizationColor: appWindow.uiver === 1 ?
                                               appWindow.theme.foreground :
                                               appWindow.theme_v2.textColor
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
                    effect: MultiEffect {
                        colorization: 1.0
                        colorizationColor: appWindow.uiver === 1 ?
                                               appWindow.theme.foreground :
                                               appWindow.theme_v2.textColor
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

        contentItem: RowLayout {
            spacing: 8*appWindow.zoom
            Loader {
                sourceComponent: appWindow.uiver === 1 ? contentItem_v1 : contentItem_v2
                Layout.fillWidth: !externalLink
            }
            SvgImage_V2 {
                visible: externalLink
                source: Qt.resolvedUrl("../../images/external_link.svg")
            }
            Item {
                visible: externalLink
                implicitWidth: 1
                implicitHeight: 1
                Layout.fillWidth: true
            }
            Rectangle {
                visible: showRectWithColor.a
                implicitWidth: appWindow.theme_v2.tagSquareSize*appWindow.zoom
                implicitHeight: implicitWidth
                color: showRectWithColor
                radius: 4*appWindow.zoom
            }
            ToolbarFlatButton_V2 {
                id: threeDotsButton
                visible: showThreeDotsBtn
                iconSource: Qt.resolvedUrl("../V2/menu_dots.svg")
                iconColor: appWindow.theme_v2.bg1000
                bgColor: "transparent"
                leftPadding: 4*appWindow.zoom
                rightPadding: leftPadding
                topPadding: leftPadding
                bottomPadding: leftPadding
                onClicked: threeDotsClicked()
            }
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onContainsMouseChanged: parent.highlighted = containsMouse
            cursorShape: parent.enabled ? Qt.PointingHandCursor: Qt.ArrowCursor
            acceptedButtons: Qt.NoButton
        }
}
