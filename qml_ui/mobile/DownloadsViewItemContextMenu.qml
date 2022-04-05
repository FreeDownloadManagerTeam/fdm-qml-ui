import QtQuick 2.10
import QtQuick.Controls 2.3
import org.freedownloadmanager.fdm 1.0
import org.freedownloadmanager.fdm.appfeatures 1.0
import org.freedownloadmanager.fdm.abstractdownloadsui 1.0
import "BaseElements"
import "../common/Tools"


Menu
{
    id: root

    property var modelIds: []
    property bool finished
    property bool hasPostFinishedTasks: false
    property var downloadModel
    property bool downloadItemPage: false
    property var priority: null
    property bool priorityVisible: selectedDownloadsTools.changePriorityAllowed()
    property bool fileIntegrityVisible: modelIds.length === 1 && root.finished === true && downloadModel.filesCount == 1
    property bool canChangeUrl: modelIds.length === 1 && downloadModel && (downloadModel.flags & AbstractDownloadsUi.AllowChangeSourceUrl) != 0
    property bool supportsMirror: modelIds.length === 1 && downloadModel && (downloadModel.flags & AbstractDownloadsUi.SupportsMirrors) != 0
    property bool supportsSequentialDownload: selectedDownloadsTools.sequentialDownloadAllowed()
    property bool supportsDisablePostFinishedTasks: false
    property bool supportsAddT: false
    property bool supportsIgnoreURatioLimit: false
    property bool locked: selectedDownloadsTools.selectedDownloadsIsLocked()
    readonly property var info: modelIds.length === 1 ? App.downloads.infos.info(modelIds[0]) : null
    readonly property var error: info ? info.error : null
    readonly property bool showReportError: error && error.hasError
    readonly property bool showAllowAutoRetry: info && (showReportError || App.downloads.autoRetryMgr.isDownloadSetToAutoRetry(modelIds[0]))
    readonly property bool showErrorBlock: showReportError || showAllowAutoRetry

    modal: true
    dim: false
    width: 260

    DownloadsItemContextMenuTools {
        id: contextMenuTools
        modelId: modelIds[0]
        finished: root.finished
    }

    transformOrigin: Menu.TopRight

/*
    BaseMenuItem {
        text: qsTr("Pause all except this one") + App.loc.emptyString
        enabled: root.running === true
//            onTriggered: App.downloads.mgr.openDownload(root.modelId)
    }

    BaseMenuSeparator {}
*/

    ActionGroup {
        id: priorityGroup
    }
    PriorityMenuItem {
        visible: priorityVisible
        text: qsTr("Set priority") + App.loc.emptyString
        enabled: false
    }
    PriorityMenuItem {
        visible: priorityVisible
        text: qsTr("High") + App.loc.emptyString
        checkable: true
        checked: selectedDownloadsTools.getDownloadsPriorityChecked(AbstractDownloadsUi.DownloadPriorityHigh)
        onTriggered: selectedDownloadsTools.setDownloadsPriority(AbstractDownloadsUi.DownloadPriorityHigh)
        ActionGroup.group: priorityGroup
    }
    PriorityMenuItem {
        visible: priorityVisible
        text: qsTr("Normal") + App.loc.emptyString
        checkable: true
        checked: selectedDownloadsTools.getDownloadsPriorityChecked(AbstractDownloadsUi.DownloadPriorityNormal)
        onTriggered: selectedDownloadsTools.setDownloadsPriority(AbstractDownloadsUi.DownloadPriorityNormal)
        ActionGroup.group: priorityGroup
    }
    PriorityMenuItem {
        visible: priorityVisible
        text: qsTr("Low") + App.loc.emptyString
        checkable: true
        checked: selectedDownloadsTools.getDownloadsPriorityChecked(AbstractDownloadsUi.DownloadPriorityLow)
        onTriggered: selectedDownloadsTools.setDownloadsPriority(AbstractDownloadsUi.DownloadPriorityLow)
        ActionGroup.group: priorityGroup
    }
    BaseMenuSeparator {
        visible: priorityVisible
    }
    BaseMenuItem {
        id: restart
        text: qsTr("Restart") + App.loc.emptyString
        visible: selectedDownloadsTools.canBeRestarted()
        enabled: !locked
        onTriggered: selectedDownloadsTools.restartDownloads()
    }
    BaseMenuItem {
        id: open
        text: qsTr("Open") + App.loc.emptyString
        visible: modelIds.length === 1 && contextMenuTools.canBeOpened
        enabled: !locked
        onTriggered: contextMenuTools.openClick()
    }
    BaseMenuItem {
        id: showInFolder
        visible: modelIds.length === 1 && contextMenuTools.canBeShownInFolder
        text: qsTr("Show in folder") + App.loc.emptyString
        onTriggered: contextMenuTools.showInFolderClick()
    }

    BaseMenuSeparator {
        visible: showErrorBlock
    }
    BaseMenuItem {
        visible: showReportError
        text: qsTr("Report problem") + App.loc.emptyString
        enabled: !locked
        onTriggered: contextMenuTools.reportProblem()
    }
    BaseMenuItem {
        visible: showAllowAutoRetry
        text: qsTr("Enable auto retry for this kind of errors") + App.loc.emptyString
        checkable: true
        enabled: !App.downloads.autoRetryMgr.isErrorAutoRetryAllowedByCore(error)
        checked: App.downloads.autoRetryMgr.isErrorAutoRetryAllowedByUser(error)
        onTriggered: {
            App.downloads.autoRetryMgr.setErrorAllowAutoRetryByUser(error, checked);
            if (checked && !info.running)
                App.downloads.mgr.startDownload(modelIds[0], false);
        }
    }

    BaseMenuSeparator {
        visible: restart.visible || open.visible || showInFolder.visible
    }
    BaseMenuItem {
        visible: modelIds.length === 1 && !downloadItemPage
        text: qsTr("Show info") + App.loc.emptyString
        onTriggered: stackView.waPush(Qt.resolvedUrl("DownloadItemPage/Page.qml"), {downloadItemId: modelIds[0]});
    }
    BaseMenuItem {
        visible: modelIds.length === 1 && !downloadItemPage && downloadModel.filesCount > 1
        text: qsTr("Files") + App.loc.emptyString
        onTriggered: stackView.waPush(Qt.resolvedUrl("DownloadItemPage/Page.qml"), {downloadItemId: modelIds[0], tabIndex: 1});
    }
    BaseMenuSeparator {
        visible: modelIds.length === 1 && !downloadItemPage
    }
    BaseMenuItem {
        text: qsTr("Move to...") + App.loc.emptyString
        enabled: !locked && selectedDownloadsTools.checkMoveAllowed()
        onTriggered: stackView.waPush(filePicker.filePickerPageComponent, {initiator: "fileMoving", downloadId: modelIds[0]});
    }
    BaseMenuItem {
        text: qsTr("Delete file") + App.loc.emptyString
        enabled: !locked
        onTriggered: {
            deleteDownloadsDialog.downloadIds = modelIds;
            deleteDownloadsDialog.open();
        }
    }
    BaseMenuItem {
        text: qsTr("Remove from list") + App.loc.emptyString
        enabled: !locked
        onTriggered: selectedDownloadsTools.removeFromList(modelIds)
    }
    BaseMenuSeparator {
        visible: supportsSequentialDownload || supportsDisablePostFinishedTasks || supportsAddT || supportsIgnoreURatioLimit
    }
    BaseMenuItem {
        visible: supportsSequentialDownload
        enabled: !locked
        text: qsTr("Sequential download") + App.loc.emptyString
        checkable: true
        checked: selectedDownloadsTools.sequentialDownloadChecked()
        onTriggered: selectedDownloadsTools.setSequentialDownload(checked)
    }
    BaseMenuItem {
        text: qsTr("Add mirror") + App.loc.emptyString
        visible: supportsMirror
        enabled: !locked
        onTriggered: {
            stackView.waPush(Qt.resolvedUrl("AddMirrorPage.qml"), {downloadModel:downloadModel})
        }
    }

    BaseMenuSeparator {
        visible: modelIds.length === 1
    }
    BaseMenuItem {
        enabled: modelIds.length === 1 && contextMenuTools.openDownloadPageAllowed()
        text: qsTr("Open download page") + App.loc.emptyString
        onTriggered: contextMenuTools.openDownloadPageClick()
    }
    BaseMenuItem {
        text: qsTr("Copy link") + App.loc.emptyString
        visible: modelIds.length === 1
        onTriggered: contextMenuTools.copyLinkClick()
    }

    BaseMenuItem {
        text: qsTr("Check for update") + App.loc.emptyString
        visible: selectedDownloadsTools.canCheckForUpdate()
        onTriggered: selectedDownloadsTools.checkForUpdate()
    }

    BaseMenuSeparator {
        visible: canChangeUrl
    }
    BaseMenuItem {
        text: qsTr("Change URL") + App.loc.emptyString
        visible: canChangeUrl
        enabled: !locked
        onTriggered: {
            stackView.waPush(Qt.resolvedUrl("ChangeUrlPage.qml"), {downloadModel:downloadModel})
        }
    }

    BaseMenuSeparator {}
    BaseMenuItem {
        enabled: !locked && selectedDownloadsTools.convertationToMp3Allowed()
        text: qsTr("Convert to mp3") + App.loc.emptyString
        onTriggered: {
            stackView.waPush(Qt.resolvedUrl("Mp3ConverterPage.qml"), {downloadsIds: modelIds, filesIndices: []})
        }
    }

    BaseMenuItem {
        enabled: !locked && selectedDownloadsTools.convertationToMp4Allowed()
        text: qsTr("Convert to mp4") + App.loc.emptyString
        onTriggered: {
            stackView.waPush(Qt.resolvedUrl("Mp4ConverterPage.qml"), {downloadsIds: modelIds, filesIndices: []})
        }
    }

    BaseMenuSeparator {
        visible: fileIntegrityVisible
    }
    BaseMenuItem {
        text: qsTr("File integrity") + App.loc.emptyString
        visible: fileIntegrityVisible
        enabled: !locked && !downloadModel.missingFiles && !downloadModel.missingStorage
        onTriggered: {
            stackView.waPush(Qt.resolvedUrl("FileIntegrityPage.qml"), {fileIndex: 0, downloadModel: downloadModel})
        }
    }
    BaseMenuSeparator {}
    BaseMenuItem {
        enabled: !locked && selectedDownloadsTools.setUpSchedulerAllowed()
        text: qsTr("Schedule") + App.loc.emptyString
        onTriggered: schedulerDlg.setUpSchedulerAction(modelIds)
    }

    Component.onCompleted: {
        if (appWindow.btSupported) {
            var index = 20;
            if (btTools.item.addTAllowed()) {
                supportsAddT = true;
                root.insertItem(index++, Qt.createQmlObject('import "../bt/mobile"; AddTMenuItem {}', root));
            }
            if (btTools.item.disablePostFinishedTasksAllowed()) {
                supportsDisablePostFinishedTasks = true;
                root.insertItem(index++, Qt.createQmlObject('import "../bt/mobile"; DisableSMenuItem {}', root));
            }
            if (btTools.item.ignoreURatioLimitAllowed()) {
                supportsIgnoreURatioLimit = true;
                root.insertItem(index++, Qt.createQmlObject('import "../bt/mobile"; IgnoreURatioMenuItem {}', root));
            }
        }
    }
}
