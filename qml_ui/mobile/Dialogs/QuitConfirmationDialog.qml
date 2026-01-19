import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.freedownloadmanager.fdm
import QtQuick.Controls.Material
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
