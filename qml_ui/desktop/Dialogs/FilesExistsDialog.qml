import QtQuick 2.10
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.11
import org.freedownloadmanager.fdm 1.0
import org.freedownloadmanager.fdm.abstractdownloadsui 1.0
import org.freedownloadmanager.fdm.dmcoresettings 1.0
import org.freedownloadmanager.fdm.appconstants 1.0
import Qt.labs.settings 1.0
import "../BaseElements"
import "../../common/Tools"

BaseDialog {
    id: root

    property int downloadId
    property int fileIndex
    property var files: []

    property int timeout: AppConstants.FileExistsActionTimeout
    property int countdown: root.timeout

    width: 542*appWindow.zoom

    contentItem: BaseDialogItem {
        titleText: qsTr("Warning: file exists already") + App.loc.emptyString
        focus: true
        Keys.onEscapePressed: root.actionSelected(AbstractDownloadsUi.DfeaAbort)
        Keys.onReturnPressed: root.actionSelected(AbstractDownloadsUi.DfeaRename)
        onCloseClick: root.actionSelected(AbstractDownloadsUi.DfeaAbort)

        ColumnLayout {
            Layout.fillWidth: true
            Layout.leftMargin: 10*appWindow.zoom
            Layout.rightMargin: 10*appWindow.zoom
            spacing: 20*appWindow.zoom

            ListView {
                clip: true
                Layout.fillWidth: true
                Layout.preferredHeight: Math.min(contentHeight, 150*appWindow.zoom)
                ScrollBar.vertical: ScrollBar {
                    active: parent.contentHeight > 150*appWindow.zoom
                }
                model: root.files
                delegate: Rectangle {
                    width: parent.width
                    height: lbl.height
                    color: 'transparent'

                    BaseLabel {
                        id: lbl
                        width: parent.width
                        elide: Text.ElideMiddle
                        text: modelData
                    }
                }
            }

            BaseCheckBox {
                id: remember
                text: qsTr("Remember my choice for all downloads") + App.loc.emptyString
            }

            RowLayout {
                Layout.topMargin: 10*appWindow.zoom
                Layout.bottomMargin: 10*appWindow.zoom
                Layout.alignment: Qt.AlignRight

                spacing: 5*appWindow.zoom

                BaseButton {
                    text: qsTr("Rename (%1)").arg(root.countdown) + App.loc.emptyString
                    blueBtn: true
                    alternateBtnPressed: abortBtn.isPressed || overwriteBtn.isPressed
                    onClicked: root.actionSelected(AbstractDownloadsUi.DfeaRename)
                }

                BaseButton {
                    id: overwriteBtn
                    text: qsTr("Overwrite") + App.loc.emptyString
                    onClicked: root.actionSelected(AbstractDownloadsUi.DfeaOverwrite)
                }

                BaseButton {
                    id: abortBtn
                    text: qsTr("Abort") + App.loc.emptyString
                    onClicked: root.actionSelected(AbstractDownloadsUi.DfeaAbort)
                }

                Timer {
                    id: countdownTimer
                    interval: 1000
                    running: false
                    repeat: true
                    onTriggered: timerHandler()
                }
            }
        }
    }

    function timerHandler() {
        root.countdown--

        if (!root.countdown) {
            root.actionSelected(AbstractDownloadsUi.DfeaRename)
        }
    }

    onOpened: {
        forceActiveFocus();
        countdown = timeout;
        countdownTimer.restart();
    }

    onClosed: {
        downloadId = -1;
        fileIndex = -1;
        files = [];
    }

    function actionSelected(action) {
        countdownTimer.stop();
        if (remember.checked) {
            if (action === AbstractDownloadsUi.DfeaRename) {
                App.settings.dmcore.setValue(DmCoreSettings.ExistingFileReaction, AbstractDownloadsUi.DefrRename);
            } else if (action === AbstractDownloadsUi.DfeaOverwrite) {
                App.settings.dmcore.setValue(DmCoreSettings.ExistingFileReaction, AbstractDownloadsUi.DefrOverwrite);
            } else if (action === AbstractDownloadsUi.DfeaAbort) {
                App.settings.dmcore.setValue(DmCoreSettings.ExistingFileReaction, AbstractDownloadsUi.DefrAsk);
            }
        }
        let downloadId_ = root.downloadId;
        let fileIndex_ = root.fileIndex;
        root.close();
        App.downloads.filesExistsActionsMgr.submitAction(downloadId_, fileIndex_, action, true);
    }
}
