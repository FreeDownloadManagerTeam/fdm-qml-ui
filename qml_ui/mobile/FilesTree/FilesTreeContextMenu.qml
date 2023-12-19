import QtQuick 2.10
import QtQuick.Controls 2.3
import org.freedownloadmanager.fdm 1.0
import org.freedownloadmanager.fdm.appfeatures 1.0
import org.freedownloadmanager.fdm.abstractdownloadsui 1.0
import "../BaseElements"

Menu {
    id: root
    property var model: null
    property var downloadModel: null
    property var downloadItemId: null
    property bool finished: false
    property bool locked: false
    property bool canBeShownInFolder: App.features.hasFeature(AppFeatures.OpenFolder) && !App.rc.client.active

    modal: true
    dim: false
    width: 260

    ActionGroup {
        id: filePriorityGroup
    }

    BaseMenuItem {
        text: qsTr("High priority") + App.loc.emptyString
        onTriggered: model.priority = AbstractDownloadsUi.DownloadPriorityHigh;
        ActionGroup.group: filePriorityGroup
    }
    BaseMenuItem {
        text: qsTr("Normal priority") + App.loc.emptyString
        onTriggered: model.priority = AbstractDownloadsUi.DownloadPriorityNormal;
        ActionGroup.group: filePriorityGroup
    }
    BaseMenuItem {
        text: qsTr("Low priority") + App.loc.emptyString
        onTriggered: model.priority = AbstractDownloadsUi.DownloadPriorityLow;
        ActionGroup.group: filePriorityGroup
    }

    BaseMenuSeparator {}

    BaseMenuItem {
        text: qsTr("Skip") + App.loc.emptyString
        onTriggered: {
            model.priority = AbstractDownloadsUi.DownloadPriorityDontDownload;
        }
    }

    BaseMenuSeparator {
        visible: openFile.visible || showFolder.visible
    }

    BaseMenuItem {
        id: openFile
        text: qsTr("Open") + App.loc.emptyString
        visible: downloadItemId && !model.folder && (model.priority != AbstractDownloadsUi.DownloadPriorityDontDownload || finished) && !App.rc.client.active
        enabled: !locked && finished
        onTriggered: App.downloads.mgr.openDownload(downloadItemId, model.fileIndex)
    }

    BaseMenuItem {
        id: showFolder
        text: qsTr("Show in folder") + App.loc.emptyString
        visible: downloadItemId && canBeShownInFolder
        onTriggered: App.downloads.mgr.openDownloadFolder(downloadItemId, model.fileIndex)
    }

    BaseMenuItem {
        text: qsTr("File integrity") + App.loc.emptyString
        visible: downloadItemId && finished
        enabled: !locked
        onTriggered: {
            stackView.waPush(Qt.resolvedUrl("../FileIntegrityPage.qml"), {fileIndex: model.fileIndex, downloadModel: downloadModel})
        }
    }

    BaseMenuSeparator {
        visible: mp3Convert.visible || mp4Convert.visible
    }
    BaseMenuItem {
        id: mp3Convert
        text: qsTr("Convert video to mp3") + App.loc.emptyString
        visible: downloadItemId && (App.downloads.infos.info(downloadItemId).fileInfo(model.fileIndex).fileType == AbstractDownloadsUi.VideoFile) ||
                 (App.downloads.infos.info(downloadItemId).fileInfo(model.fileIndex).fileType == AbstractDownloadsUi.AudioFile)
        enabled: downloadItemId && finished && !locked && visible
        onTriggered: {
            stackView.waPush(Qt.resolvedUrl("../Mp3ConverterPage.qml"), {downloadsIds: [downloadItemId], filesIndices: [model.fileIndex]})
        }
    }

    BaseMenuItem {
        id: mp4Convert
        text: qsTr("Convert to mp4") + App.loc.emptyString
        visible: downloadItemId &&
                 App.downloads.infos.info(downloadItemId).fileInfo(model.fileIndex).fileType == AbstractDownloadsUi.VideoFile &&
                 App.downloads.infos.info(downloadItemId).fileInfo(model.fileIndex).suffix.toUpperCase() !== "MP4"
        enabled: downloadItemId && finished && !locked && visible
        onTriggered: {
            stackView.waPush(Qt.resolvedUrl("../Mp4ConverterPage.qml"), {downloadsIds: [downloadItemId], filesIndices: [model.fileIndex]})
        }
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
