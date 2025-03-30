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
    property bool v2EnableRicherBgColor: false

    readonly property bool isEnabled: enabled && !locked

    padding: 0
    focusPolicy: Qt.NoFocus

    implicitWidth: text.length > 0 ? contentItem.implicitWidth : (xOffset + indicator.implicitWidth)
    implicitHeight: text.length > 0 ? Math.max(indicator.implicitHeight, contentItem.implicitHeight) : indicator.implicitHeight

    indicator: Rectangle {
        x: LayoutMirroring.enabled ? root.width - width - root.xOffset : root.xOffset
        anchors.verticalCenter: parent.verticalCenter

        implicitWidth: appWindow.uiver === 1 ? 12*appWindow.zoom : indicatorImage.implicitWidth
        implicitHeight: appWindow.uiver === 1 ? 12*appWindow.zoom : indicatorImage.implicitHeight

        radius: appWindow.uiver === 1 ? 0 : 4*appWindow.zoom

        color: appWindow.uiver === 1 ?
                   "transparent" :
                   (checked ?
                        (isEnabled ? appWindow.theme_v2.primary : appWindow.theme_v2.bg400) :
                        (v2EnableRicherBgColor ? appWindow.theme_v2.bg100 : appWindow.theme_v2.bg200))

        border.color: appWindow.uiver === 1 ?
                          "transparent" :
                          (checked ?
                               (isEnabled ? appWindow.theme_v2.primary : appWindow.theme_v2.bg400) :
                               appWindow.theme_v2.bg400)

        border.width: appWindow.uiver === 1 ?
                          0 :
                          1*appWindow.zoom

        WaSvgImage {
            id: indicatorImage

            source: appWindow.uiver === 1 ?
                        (appWindow.theme.checkboxIconsRoot + "/" + checkBoxStyle + "/" +
                         (checkState === Qt.Checked ? "checked" : checkState === Qt.Unchecked ? "unchecked" : "indeterminate") +
                         ".svg") :
                        Qt.resolvedUrl("V2/checkmark_v2.svg")

            zoom: appWindow.zoom

            visible: appWindow.uiver === 1 ? true : checked

            anchors.centerIn: parent

            opacity: root.isEnabled ? 1.0 : 0.4

            layer {
                effect: ColorOverlay {
                    color: appWindow.uiver === 1 ?
                               appWindow.theme.inactiveControl :
                               (root.isEnabled ? appWindow.theme_v2.bg200 : appWindow.theme_v2.bg1000)
                }
                enabled: appWindow.uiver === 1 ? !Window.active : true
            }
        }
    }

    contentItem: BaseLabel {
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        leftPadding: qtbug.leftPadding(root.xOffset + root.indicator.width + (root.text ? 8*appWindow.zoom : 0), 0)
        rightPadding: qtbug.rightPadding(root.xOffset + root.indicator.width + (root.text ? 8*appWindow.zoom : 0), 0)
        text: parent.text
        color: parent.textColor ? parent.textColor : appWindow.theme.foreground
        font.pixelSize: fontSize
        width: parent.width
        elide: elideText ? Label.ElideRight : Text.ElideNone
        wrapMode: elideText ? Text.NoWrap : Text.WordWrap
    }
}
