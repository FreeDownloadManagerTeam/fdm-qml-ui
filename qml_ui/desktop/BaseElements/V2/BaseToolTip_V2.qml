import QtQuick
import QtQuick.Controls

ToolTip {
    id: root
    delay: Qt.styleHints.mousePressAndHoldInterval
    timeout: 12000

    contentItem: BaseText_V2 {
        text: root.text
        font.pixelSize: appWindow.theme_v2.tooltipFontSize * appWindow.fontZoom
        wrapMode: Text.Wrap
    }

    background: Rectangle {
        color: appWindow.theme_v2.popupBgColor
        radius: 4*appWindow.zoom
    }
}
