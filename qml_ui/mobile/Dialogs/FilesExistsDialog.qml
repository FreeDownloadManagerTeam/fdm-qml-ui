import QtQuick 2.10
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.11
import org.freedownloadmanager.fdm 1.0
import org.freedownloadmanager.fdm.abstractdownloadsui 1.0
import org.freedownloadmanager.fdm.dmcoresettings 1.0
import org.freedownloadmanager.fdm.appconstants 1.0
import "../BaseElements"

Dialog {
    id: root

    property int downloadId
    property int fileIndex
    property var files: []

    property int timeout: AppConstants.FileExistsActionTimeout
    property int countdown: root.timeout

    parent: appWindow.overlay

    x: Math.round((appWindow.width - width) / 2)
    y: Math.round((appWindow.height - height) / 2)

    modal: true

    title: qsTr("Warning: file exists already") + App.loc.emptyString
    width: Math.round(appWindow.width * 0.8)

    contentItem: ColumnLayout {
        width: parent.width

        ListView {
            clip: true
            Layout.fillWidth: true
            Layout.preferredHeight: Math.min(contentHeight, 150)
            ScrollBar.vertical: ScrollBar {
                active: parent.contentHeight > 150
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
            Layout.topMargin: 10
            Layout.bottomMargin: 10
            Layout.alignment: Qt.AlignRight

            spacing: 5

            DialogButton {
                text: qsTr("Rename (%1)").arg(root.countdown) + App.loc.emptyString
                onClicked: root.actionSelected(AbstractDownloadsUi.DfeaRename)
            }

            DialogButton {
                text: qsTr("Overwrite") + App.loc.emptyString
                onClicked: root.actionSelected(AbstractDownloadsUi.DfeaOverwrite)
            }

            DialogButton {
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
        App.downloads.filesExistsActionsMgr.submitAction(downloadId, fileIndex, action, true);
        root.close();
    }
}
