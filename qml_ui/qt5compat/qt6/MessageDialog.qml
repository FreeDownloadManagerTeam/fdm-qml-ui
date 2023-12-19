import QtQuick 2.0
import Qt.labs.platform 1.1

MessageDialog
{
    readonly property int buttonOk: MessageDialog.Ok
    readonly property int buttonCancel: MessageDialog.Cancel
    buttons: buttonOk
}
