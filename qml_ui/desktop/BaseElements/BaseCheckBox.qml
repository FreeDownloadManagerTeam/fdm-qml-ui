import QtQuick 2.6
import QtQuick.Controls 2.1
import QtGraphicalEffects 1.0
import QtQuick.Window 2.12

CheckBox {
    id: root
    property string checkBoxStyle: "blue"
    property string textColor
    property int fontSize: 14
    property bool truncated: contentItem.truncated
    property bool elideText: true
    property bool locked: false

    property int xOffset: 6

    padding: 0
    focusPolicy: Qt.NoFocus

    implicitWidth: xOffset + indicator.width + (text.length > 0 ? contentItem.implicitWidth + 8 : 0)
    implicitHeight: text.length > 0 ? Math.max(indicator.height, contentItem.implicitHeight) : indicator.height

    indicator: Rectangle {
        color: "transparent"
        anchors.verticalCenter: parent.verticalCenter
        x: root.xOffset
        width: 12
        height: 12
        clip: true

        Image {
            x: checkBoxStyle === "gray" ? (
                       checkState === Qt.Checked ? -180 :
                       checkState === Qt.Unchecked ? -160 : -200)
                   : (
                checkBoxStyle === "black" ? (
                    checkState === Qt.Checked ? -120 :
                    checkState === Qt.Unchecked ? -100 : -140)
                : (
                    checkState === Qt.Checked ? -40 :
                    checkState === Qt.Unchecked ? 0 : -20
            ))
            y: -44
            source: appWindow.theme.checkboxIcons
            sourceSize.width: 212
            sourceSize.height: 76
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
        anchors.verticalCenter: parent.verticalCenter
        leftPadding: root.xOffset + root.indicator.width + 8
        text: parent.text
        color: parent.textColor ? parent.textColor : appWindow.theme.foreground
        font.pixelSize: fontSize
        width: parent.width
        elide: elideText ? Label.ElideRight : Text.ElideNone
        wrapMode: elideText ? Text.NoWrap : Text.WordWrap
    }
}
