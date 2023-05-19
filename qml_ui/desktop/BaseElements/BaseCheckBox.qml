import QtQuick 2.6
import QtQuick.Controls 2.1
import QtQuick.Window 2.12
import "../../qt5compat"
import "../../common"

CheckBox {
    id: root
    property string checkBoxStyle: "blue"
    property string textColor
    property int fontSize: 14*appWindow.fontZoom
    property bool truncated: contentItem.truncated
    property bool elideText: true
    property bool locked: false

    property int xOffset: 6*appWindow.zoom

    padding: 0
    focusPolicy: Qt.NoFocus

    implicitWidth: text.length > 0 ? contentItem.implicitWidth : (xOffset + indicator.width)
    implicitHeight: text.length > 0 ? Math.max(indicator.height, contentItem.implicitHeight) : indicator.height

    indicator: Rectangle {
        color: "transparent"
        anchors.verticalCenter: parent.verticalCenter
        x: LayoutMirroring.enabled ? root.width - width - root.xOffset : root.xOffset
        width: 12*appWindow.zoom
        height: 12*appWindow.zoom
        clip: true

        WaSvgImage {
            x: (checkBoxStyle === "gray" ? (
                       checkState === Qt.Checked ? -180 :
                       checkState === Qt.Unchecked ? -160 : -200)
                   : (
                checkBoxStyle === "black" ? (
                    checkState === Qt.Checked ? -120 :
                    checkState === Qt.Unchecked ? -100 : -140)
                : (
                    checkState === Qt.Checked ? -40 :
                    checkState === Qt.Unchecked ? 0 : -20
            )))*zoom
            y: -44*zoom
            source: appWindow.theme.checkboxIcons
            zoom: appWindow.zoom
            opacity: root.locked || !root.enabled ? 0.4 : 1
            layer {
                effect: ColorOverlay {
                    color: appWindow.theme.inactiveControl
                }
                enabled: !Window.active
            }
        }
    }

    contentItem: BaseLabel {
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        leftPadding: qtbug.leftPadding(root.xOffset + root.indicator.width + 8*appWindow.zoom, 0)
        rightPadding: qtbug.rightPadding(root.xOffset + root.indicator.width + 8*appWindow.zoom, 0)
        text: parent.text
        color: parent.textColor ? parent.textColor : appWindow.theme.foreground
        font.pixelSize: fontSize
        width: parent.width
        elide: elideText ? Label.ElideRight : Text.ElideNone
        wrapMode: elideText ? Text.NoWrap : Text.WordWrap
    }
}
