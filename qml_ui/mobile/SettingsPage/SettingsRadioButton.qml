import QtQuick 2.11
import QtQuick.Controls 2.5
import "../../qt5compat"

RadioButton
{
    id: control
    leftPadding: 0
    rightPadding: 0

    indicator: Rectangle {
        implicitWidth: 18
        implicitHeight: 18
        x: LayoutMirroring.enabled ?
               parent.width - width - qtbug.getLeftPadding(control) :
               qtbug.getLeftPadding(control)
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
        leftPadding: qtbug.leftPadding(control.indicator.width + control.spacing, 0)
        rightPadding: qtbug.rightPadding(control.indicator.width + control.spacing, 0)
        wrapMode: Label.WordWrap
    }
}
