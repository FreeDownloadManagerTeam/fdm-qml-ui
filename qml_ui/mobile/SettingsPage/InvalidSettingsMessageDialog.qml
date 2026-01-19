import QtQuick
import "../Dialogs"
import org.freedownloadmanager.fdm

AppMessageDialog
{
    id: root
    signal popPage()
    property string lastInvalidSettingsMessage: ""

    title: "Invalid settings"
    text: root.lastInvalidSettingsMessage + qsTr(". Close anyway?") + App.loc.emptyString
    buttons: buttonOk | buttonCancel
    onOkClicked: popPage()
}
