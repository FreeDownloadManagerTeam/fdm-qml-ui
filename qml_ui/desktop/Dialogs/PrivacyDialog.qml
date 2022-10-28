import QtQuick 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import org.freedownloadmanager.fdm 1.0

import "../../common/Tools"
import "../BaseElements"
import "../../common"

BaseDialog {
    id: root

    width: 400*appWindow.zoom

    property int failedId

    contentItem: BaseDialogItem {
        titleText: qsTr("User agreement") + App.loc.emptyString
        focus: true

        onCloseClick: root.reject()

        Keys.onEscapePressed: root.reject()

        Keys.onReturnPressed: root.accept()

        ColumnLayout {
            width: parent.width
            Layout.leftMargin: 10*appWindow.zoom
            Layout.rightMargin: 10*appWindow.zoom
            spacing: 20*appWindow.zoom

            BaseLabel {
                text: qsTr("A bug report will be sent to the server and used to improve %1 performance. We do not collect your personal data and do not share data with third parties.").arg(App.shortDisplayName) + App.loc.emptyString
                Layout.fillWidth: true
                wrapMode: Label.WordWrap
            }

            BaseCheckBox {
                id: agree
                text: qsTr("I agree (do not show it again)") + App.loc.emptyString
                xOffset: 0
            }

            RowLayout {
                Layout.topMargin: 10*appWindow.zoom
                Layout.bottomMargin: 10*appWindow.zoom
                Layout.alignment: Qt.AlignRight

                spacing: 5*appWindow.zoom

                CustomButton {
                    id: okBtn
                    text: qsTr("Send report") + App.loc.emptyString
                    onClicked: root.accept()
                    blueBtn: true
                    alternateBtnPressed: cnclBtn.isPressed
                    enabled: agree.checked
                }

                CustomButton {
                    id: cnclBtn
                    text: qsTr("Cancel") + App.loc.emptyString
                    onClicked: root.reject()
                }
            }
        }
    }

    onOpened: forceActiveFocus()
    onClosed: {
        failedId = -1;
        appWindow.appWindowStateChanged();
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
