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

    readonly property int availWidth: appWindow.width*0.95

    closePolicy: Popup.NoAutoClose

    parent: Overlay.overlay

    x: Math.round((appWindow.width - width) / 2)
    y: Math.round((appWindow.height - height) / 2)

    modal: true

    title: qsTr("Warning: file exists already") + App.loc.emptyString

    contentItem: ColumnLayout {

        ListView {
            clip: true
            Layout.fillWidth: true
            Layout.preferredHeight: Math.min(contentHeight, 150)
            Layout.maximumWidth: root.availWidth
            ScrollBar.vertical: ScrollBar {
                active: parent.contentHeight > 150
            }
            model: root.files
            delegate: BaseLabel {
                id: lbl
                width: parent.width
                elide: Text.ElideMiddle
                text: modelData
            }
        }

        BaseCheckBox {
            id: remember
            text: qsTr("Remember my choice for all downloads") + App.loc.emptyString
        }

        GridLayout {
            Layout.topMargin: 10
            Layout.bottomMargin: 10
            Layout.alignment: Qt.AlignRight
            Layout.maximumWidth: root.availWidth

            rowSpacing: 0
            columnSpacing: 0

            readonly property bool hasSpace: b1.implicitWidth + b2.implicitWidth + b3.implicitWidth + 30 <= root.availWidth
            columns: hasSpace ? -1 : 1
            rows: hasSpace ? 1 : -1

            DialogButton {
                id: b1
                text: qsTr("Rename (%1)").arg(root.countdown) + App.loc.emptyString
                onClicked: root.actionSelected(AbstractDownloadsUi.DfeaRename)
            }

            DialogButton {
                id: b2
                text: qsTr("Overwrite") + App.loc.emptyString
                onClicked: root.actionSelected(AbstractDownloadsUi.DfeaOverwrite)
            }

            DialogButton {
                id: b3
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
