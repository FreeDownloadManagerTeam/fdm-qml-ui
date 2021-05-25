import QtQuick 2.0
import QtQuick.Dialogs 1.1
import org.freedownloadmanager.fdm 1.0

MessageDialog
{
    id: root
    signal popPage()
    property string lastInvalidSettingsMessage: ""

    title: "Invalid settings"
    text: root.lastInvalidSettingsMessage + qsTr(". Close anyway?") + App.loc.emptyString
    standardButtons: StandardButton.Ok | StandardButton.Cancel
    //onAccepted: root.StackView.view.pop()
    onAccepted: popPage()
}
