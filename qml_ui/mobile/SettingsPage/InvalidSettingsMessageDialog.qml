import QtQuick 2.0
import "../../qt5compat"
import org.freedownloadmanager.fdm 1.0

MessageDialog
{
    id: root
    signal popPage()
    property string lastInvalidSettingsMessage: ""

    title: "Invalid settings"
    text: root.lastInvalidSettingsMessage + qsTr(". Close anyway?") + App.loc.emptyString
    buttons: buttonOk | buttonCancel
    onAccepted: popPage()
}
