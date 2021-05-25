import QtQuick 2.0
import QtQuick.Controls 2.3

ToolTip {
    id: root
    delay: Qt.styleHints.mousePressAndHoldInterval
    timeout: 12000
    property int fontSize: 13

    contentItem: Text {
        text: root.text
        font.pixelSize: fontSize
        font.weight: Font.Light
        wrapMode: Text.Wrap
        color: appWindow.theme.toolTipText
    }

    background: Rectangle {
        color: appWindow.theme.toolTipBackground
        border.color: appWindow.theme.toolTipBorder
    }
}
