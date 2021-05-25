import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import org.freedownloadmanager.fdm 1.0
import QtQuick.Controls.Material 2.4
import "../../common"
import "../BaseElements"

CenteredDialog
{
    id: root
    width: 320

    property string message: ""

    modal: true

    title: qsTr("Are you sure you want to quit?") + App.loc.emptyString

    Label
    {
        text: root.message
        wrapMode: Label.WordWrap
        width: root.width - 20
    }

    standardButtons: Dialog.Ok | Dialog.Cancel

    onAccepted: App.reportQuitConfirmationResult(true);
    onRejected: App.reportQuitConfirmationResult(false);
}
