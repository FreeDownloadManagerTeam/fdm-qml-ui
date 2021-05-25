import QtQuick 2.11
import QtQuick.Controls 2.5
import QtGraphicalEffects 1.0

RadioButton
{
    id: control
    leftPadding: 0

    indicator: Rectangle {
        implicitWidth: 18
        implicitHeight: 18
        x: control.leftPadding
        y: parent.height / 2 - height / 2
        radius: 9
        color: control.checked ? appWindow.theme.toolbarBackground : "transparent"
        border.color: appWindow.theme.toolbarBackground
        border.width: 2

        Rectangle {
            width: 8
            height: 8
            x: 5
            y: 5
            radius: 4
            color: "#FFFFFF"
            visible: control.checked
        }
    }

    contentItem: Label {
        text: control.text
        font: control.font
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        leftPadding: control.indicator.width + control.spacing
        wrapMode: Label.WordWrap
    }
}
