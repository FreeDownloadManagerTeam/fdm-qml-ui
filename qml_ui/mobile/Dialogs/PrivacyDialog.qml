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

    modal: true

    property int failedId

    contentItem: ColumnLayout {
        width: parent.width
        spacing: 10
        anchors.leftMargin: 20
        anchors.rightMargin: 20

        Label
        {
            text: qsTr("A bug report will be sent to the server and used to improve %1 performance. We do not collect your personal data and do not share data with third parties.").arg(App.shortDisplayName) + App.loc.emptyString
            Layout.fillWidth: true
            Layout.maximumWidth: Math.min(400, appWindow.width*0.9-40)
            wrapMode: Label.WordWrap
            horizontalAlignment: Text.AlignLeft
        }

        BaseCheckBox {
            id: agree
            text: qsTr("I agree (do not show it again)") + App.loc.emptyString
        }

        RowLayout {
            Layout.topMargin: 10
            Layout.bottomMargin: 10
            Layout.alignment: Qt.AlignRight

            spacing: 5

            DialogButton {
                text: qsTr("Send report") + App.loc.emptyString
                onClicked: root.accept()
                Layout.alignment: Qt.AlignHCenter
                enabled: agree.checked
            }

            DialogButton {
                text: qsTr("Cancel") + App.loc.emptyString
                onClicked: root.reject()
                Layout.alignment: Qt.AlignHCenter
            }
        }
    }

    onOpened: forceActiveFocus()
    onClosed: {
        failedId = -1;
    }

    function showDialog(id) {
        failedId = id;
        open();
    }

    function accept() {
        uiSettingsTools.settings.reportProblemAccept = true;
        App.downloads.errorsReportsMgr.reportError(failedId);
        appWindow.reportError(failedId);
        close();
    }

    function reject() {
        close();
    }
}
