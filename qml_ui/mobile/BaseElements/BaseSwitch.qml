import QtQuick 2.10
import QtQuick.Controls 2.3

Switch {
    id: control

    indicator: Rectangle {
        implicitWidth: 38
        implicitHeight: 14
        x: LayoutMirroring.enabled ?
               parent.width - width - qtbug.getLeftPadding(control) :
               qtbug.getLeftPadding(control)
        y: parent.height / 2 - height / 2
        radius: 7
        color: control.checked ? appWindow.theme.switchBackgroundOn : appWindow.theme.switchBackgroundOff
        opacity: enabled ? 1 : 0.5

        Rectangle {
            x: LayoutMirroring.enabled ?
                   (control.checked ? 0 : parent.width - width) :
                   (control.checked ? parent.width - width : 0)
            y: parent.height / 2 - height / 2
            width: 20
            height: 20
            radius: 10
            color: control.checked ? appWindow.theme.switchTumblerOn : appWindow.theme.switchTumblerOff
        }
    }
}
