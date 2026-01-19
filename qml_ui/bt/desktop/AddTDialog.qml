import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../../desktop/BaseElements"
import "../../desktop/Dialogs"
import org.freedownloadmanager.fdm

BaseDialog {
    id: root

    property var downloadIds

    title: App.my_BT_qsTranslate("AddTrackersDialog", "Add trackers") + App.loc.emptyString
    onCloseClick: cancel()

    contentItem: BaseDialogItem {
        Keys.onEscapePressed: cancel()

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 7*appWindow.zoom

            BaseTextArea {
                id: trackers
                Layout.preferredWidth: 540*appWindow.zoom
                Layout.preferredHeight: 60*appWindow.zoom
            }

            RowLayout {
                Layout.topMargin: 10*appWindow.zoom
                Layout.alignment: Qt.AlignRight
                Layout.fillWidth: true

                spacing: 5*appWindow.zoom

                BaseButton {
                    id: cnclBtn
                    text: qsTr("Cancel") + App.loc.emptyString
                    onClicked: cancel()
                    Layout.alignment: Qt.AlignRight
                }

                BaseButton {
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
