import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Controls.Material
import "../../mobile/BaseElements"
import "../../mobile/Dialogs"
import org.freedownloadmanager.fdm

Page {
    property var downloadIds

    header: Column {
        height: 108
        width: parent.width

        BaseToolBar {
            RowLayout {
                anchors.fill: parent

                ToolbarBackButton {
                    onClicked: cancel()
                }

                ToolbarLabel {
                    text: App.my_BT_qsTranslate("AddTrackersPage", "Add trackers") + App.loc.emptyString
                    Layout.fillWidth: true
                }

                DialogButton {
                    text: qsTr("OK") + App.loc.emptyString
                    Layout.leftMargin: qtbug.leftMargin(0, 10)
                    Layout.rightMargin: qtbug.rightMargin(0, 10)
                    textColor: appWindow.theme.toolbarTextColor
                    enabled: trackers.text.trim() != ''
                    onClicked: doOK()
                }
            }
        }
    }

    TextArea {
        id: trackers
        anchors {
            left: parent.left
            right: parent.right
            margins: 20
        }
        selectByMouse: true
        inputMethodHints: Qt.ImhNoAutoUppercase | Qt.ImhNoPredictiveText | Qt.ImhSensitiveData
        wrapMode: TextArea.Wrap
        focus: true
    }

    Component.onCompleted: {
        trackers.text = uiSettingsTools.settings.btAddTString;
        trackers.selectAll();
        forceActiveFocus();
    }

    function doOK() {
        App.downloads.mgr.doCustomCommand(downloadIds, "addTrackers", trackers.text.trim());
        uiSettingsTools.settings.btAddTString = trackers.text.trim();
        stackView.pop();
    }

    function cancel() {
        uiSettingsTools.settings.btAddTString = trackers.text.trim();
        stackView.pop();
    }
}
