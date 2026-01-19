import QtQuick
import Qt.labs.platform as QtLabs

QtLabs.MessageDialog
{
    readonly property int buttonOk: QtLabs.MessageDialog.Ok
    readonly property int buttonCancel: QtLabs.MessageDialog.Cancel
    buttons: buttonOk
}
