import QtQuick 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import "../../desktop/BaseElements"
import "../../desktop/Dialogs"
import org.freedownloadmanager.fdm 1.0

BaseDialog {
    id: root

    width: 542

    property var downloadIds

    contentItem: BaseDialogItem {
        titleText: App.my_BT_qsTranslate("AddTrackersDialog", "Add trackers") + App.loc.emptyString
        Keys.onEscapePressed: cancel()
        onCloseClick: cancel()

        ColumnLayout {
            Layout.fillWidth: true
            Layout.leftMargin: 10
            Layout.rightMargin: 10
            spacing: 7

            BaseTextArea {
                id: trackers
                Layout.fillWidth: true
                Layout.preferredHeight: 60
            }

            RowLayout {
                Layout.topMargin: 10
                Layout.bottomMargin: 10
                Layout.alignment: Qt.AlignRight
                Layout.fillWidth: true

                spacing: 5

                CustomButton {
                    id: cnclBtn
                    text: qsTr("Cancel") + App.loc.emptyString
                    onClicked: cancel()
                    Layout.alignment: Qt.AlignRight
                }

                CustomButton {
                    text: qsTr("OK") + App.loc.emptyString
                    blueBtn: true
                    alternateBtnPressed: cnclBtn.isPressed
                    enabled: trackers.text.trim() != ''
                    onClicked: root.doOK()
                    Layout.alignment: Qt.AlignRight
                }
            }
        }
    }

    onClosed: {appWindow.appWindowStateChanged();}

    function showDialog(ids)
    {
        downloadIds = ids;
        trackers.text = uiSettingsTools.settings.btAddTString;
        root.open();
        trackers.selectAll();
        root.forceActiveFocus();
    }

    function doOK()
    {
        App.downloads.mgr.doCustomCommand(downloadIds, "addTrackers", trackers.text.trim());
        uiSettingsTools.settings.btAddTString = trackers.text.trim();
        root.close();
    }

    function cancel() {
        uiSettingsTools.settings.btAddTString = trackers.text.trim();
        root.close();
    }
}
