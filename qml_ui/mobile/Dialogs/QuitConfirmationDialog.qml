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

    width: Math.min(Math.round(Overlay.overlay.width * 0.8), 300)

    property string message: ""

    modal: true

    title: qsTr("Are you sure you want to quit?") + App.loc.emptyString

    Label
    {
        text: root.message
        wrapMode: Label.WordWrap
        width: root.width-40
        horizontalAlignment: Text.AlignLeft
    }

    standardButtons: Dialog.Ok | Dialog.Cancel

    onAccepted: App.reportQuitConfirmationResult(true);
    onRejected: App.reportQuitConfirmationResult(false);
}
