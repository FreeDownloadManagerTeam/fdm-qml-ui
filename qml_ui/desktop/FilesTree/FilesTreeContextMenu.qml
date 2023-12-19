import QtQuick 2.10
import QtQuick.Controls 2.3
import org.freedownloadmanager.fdm 1.0
import org.freedownloadmanager.fdm.abstractdownloadsui 1.0
import "../BaseElements"

BaseContextMenu {
    id: root
    property var model: null
    property var downloadItemId: null
    property bool finished: false
    property bool locked: false

    transformOrigin: Menu.TopRight

    ActionGroup {
        id: filePriorityGroup
    }

    BaseContextMenuItem {
        text: qsTr("High priority") + App.loc.emptyString
        onTriggered: model.priority = AbstractDownloadsUi.DownloadPriorityHigh;
        ActionGroup.group: filePriorityGroup
    }
    BaseContextMenuItem {
        text: qsTr("Normal priority") + App.loc.emptyString
        onTriggered: model.priority = AbstractDownloadsUi.DownloadPriorityNormal;
        ActionGroup.group: filePriorityGroup
    }
    BaseContextMenuItem {
        text: qsTr("Low priority") + App.loc.emptyString
        onTriggered: model.priority = AbstractDownloadsUi.DownloadPriorityLow;
        ActionGroup.group: filePriorityGroup
    }

    BaseContextMenuSeparator {}

    BaseContextMenuItem {
        text: qsTr("Skip") + App.loc.emptyString
        onTriggered: {
            model.priority = AbstractDownloadsUi.DownloadPriorityDontDownload;
        }
    }

    BaseContextMenuSeparator {
        visible: openFile.visible || showFolder.visible
    }

    BaseContextMenuItem {
        id: openFile
        text: qsTr("Open") + App.loc.emptyString
        visible: !App.rc.client.active && downloadItemId && !model.folder && (model.priority != AbstractDownloadsUi.DownloadPriorityDontDownload || finished)
        enabled: !locked && finished
        onTriggered: App.downloads.mgr.openDownload(downloadItemId, model.fileIndex);
    }

    BaseContextMenuItem {
        id: showFolder
        text: qsTr("Show in folder") + App.loc.emptyString
        visible: !App.rc.client.active && downloadItemId && !model.folder
        onTriggered: App.downloads.mgr.openDownloadFolder(downloadItemId, model.fileIndex);
    }

    BaseContextMenuItem {
        text: qsTr("File integrity") + App.loc.emptyString
        visible: downloadItemId && finished
        enabled: !locked
        onTriggered: fileIntegrityDlg.showRequestData(downloadItemId, model.fileIndex)
    }

    BaseContextMenuSeparator {
        visible: mp3Convert.visible || mp4Convert.visible
    }
    BaseContextMenuItem {
        id: mp3Convert
        text: qsTr("Convert video to mp3") + App.loc.emptyString
        visible: downloadItemId && (App.downloads.infos.info(downloadItemId).fileInfo(model.fileIndex).fileType == AbstractDownloadsUi.VideoFile) ||
                 (App.downloads.infos.info(downloadItemId).fileInfo(model.fileIndex).fileType == AbstractDownloadsUi.AudioFile)
        enabled: downloadItemId && finished && !locked && visible
        onTriggered: mp3ConverterDlg.open([downloadItemId], [model.fileIndex])
    }

    BaseContextMenuItem {
        id: mp4Convert
        text: qsTr("Convert video to mp4") + App.loc.emptyString
        visible: downloadItemId &&
                 App.downloads.infos.info(downloadItemId).fileInfo(model.fileIndex).fileType == AbstractDownloadsUi.VideoFile &&
                 App.downloads.infos.info(downloadItemId).fileInfo(model.fileIndex).suffix.toUpperCase() !== "MP4"
        enabled: downloadItemId && finished && !locked && visible
        onTriggered: mp4ConverterDlg.open([downloadItemId], [model.fileIndex])
    }

    Connections {
        target: appWindow
        onActiveChanged: {
            if (!appWindow.active) {
                close()
            }
        }
    }
}
