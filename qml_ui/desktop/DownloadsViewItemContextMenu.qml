import QtQuick 2.10
import QtQuick.Controls 2.3
import org.freedownloadmanager.fdm 1.0
import org.freedownloadmanager.fdm.appfeatures 1.0
import org.freedownloadmanager.fdm.abstractdownloadsui 1.0
import "BaseElements"
import "../common/Tools";

BaseContextMenu {
    id: root
    property var modelIds: []
    property bool finished
    property bool canChangeUrl
    property bool supportsMirror
    property bool batchDownload
    property bool supportsSequentialDownload: selectedDownloadsTools.sequentialDownloadAllowed()
    property bool supportsDisablePostFinishedTasks: false
    property bool supportsAddT: false
    property bool supportsForceReann: false
    property bool supportsIgnoreURatioLimit: false
    property int filesCount: 0
    property bool fileIntegrityVisible: root.finished === true && root.filesCount == 1
    property bool locked: selectedDownloadsTools.selectedDownloadsIsLocked()
    readonly property var info: modelIds.length === 1 ? App.downloads.infos.info(modelIds[0]) : null
    readonly property var error: info ? info.error : null
    readonly property bool showReportError: error && error.hasError
    readonly property bool showAllowAutoRetry: info && (showReportError || App.downloads.autoRetryMgr.isDownloadSetToAutoRetry(modelIds[0]))
    readonly property bool showErrorBlock: showReportError || showAllowAutoRetry

    DownloadsItemContextMenuTools {
        id: contextMenuTools
        modelId: root.modelIds[0]
        finished: root.finished
    }

    transformOrigin: Menu.TopRight

    BaseContextMenuItem {
        id: restartItem
        text: qsTr("Restart") + App.loc.emptyString
        visible: selectedDownloadsTools.canBeRestarted()
        enabled: !locked
        onTriggered: selectedDownloadsTools.restartDownloads()
    }
    BaseContextMenuItem {
        id: openItem
        text: qsTr("Open") + App.loc.emptyString
        visible: !App.rc.client.active
        enabled: !locked && modelIds.length === 1 && contextMenuTools.canBeOpened
        onTriggered: contextMenuTools.openClick()
    }
    BaseContextMenuItem {
        id: showInFolderItem
        enabled: modelIds.length === 1 && contextMenuTools.canBeShownInFolder
        text: qsTr("Show In Folder") + App.loc.emptyString
        visible: !App.rc.client.active
        onTriggered: contextMenuTools.showInFolderClick()
    }

    BaseContextMenuSeparator {
        visible: restartItem.visible || openItem.visible || showInFolderItem.visible
    }

    BaseContextMenuItem {
        visible: showReportError
        text: qsTr("Report problem") + App.loc.emptyString
        enabled: !locked
        onTriggered: contextMenuTools.reportProblem()
    }
    BaseContextMenuItem {
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
    BaseContextMenuSeparator {
        visible: showErrorBlock
    }

    BaseContextMenuItem {
        text: qsTr("Show Downloads") + App.loc.emptyString
        visible: modelIds.length === 1 && batchDownload
        onTriggered: downloadsViewTools.setParentDownloadIdFilter(contextMenuTools.modelId)
    }
    BaseContextMenuSeparator {
        visible: modelIds.length === 1 && batchDownload
    }

    BaseContextMenuItem {
        text: qsTr("Choose Files...") + App.loc.emptyString
        visible: modelIds.length === 1 && filesCount > 1
        onTriggered: bottomPanelTools.openFilesTab()
    }
    BaseContextMenuSeparator {
        visible: modelIds.length === 1 && filesCount > 1
    }

    BaseContextMenu {
        title: qsTr("Set Priority") + App.loc.emptyString
        enabled: selectedDownloadsTools.changePriorityAllowed()

        ActionGroup {
            id: downloadPriorityGroup
        }

        Action {
            text: qsTr("High") + App.loc.emptyString
            checkable: true
            checked: selectedDownloadsTools.getDownloadsPriorityChecked(AbstractDownloadsUi.DownloadPriorityHigh)
            onTriggered: selectedDownloadsTools.setDownloadsPriority(AbstractDownloadsUi.DownloadPriorityHigh)
            ActionGroup.group: downloadPriorityGroup
        }
        Action {
            text: qsTr("Normal") + App.loc.emptyString
            checkable: true
            checked: selectedDownloadsTools.getDownloadsPriorityChecked(AbstractDownloadsUi.DownloadPriorityNormal)
            onTriggered: selectedDownloadsTools.setDownloadsPriority(AbstractDownloadsUi.DownloadPriorityNormal)
            ActionGroup.group: downloadPriorityGroup
        }
        Action {
            text: qsTr("Low") + App.loc.emptyString
            checkable: true
            checked: selectedDownloadsTools.getDownloadsPriorityChecked(AbstractDownloadsUi.DownloadPriorityLow)
            onTriggered: selectedDownloadsTools.setDownloadsPriority(AbstractDownloadsUi.DownloadPriorityLow)
            ActionGroup.group: downloadPriorityGroup
        }
    }
    BaseContextMenuSeparator {}

    BaseContextMenuItem {
        text: qsTr("Rename file") + App.loc.emptyString
        visible: root.finished === true && root.filesCount == 1
        enabled: !locked && selectedDownloadsTools.checkRenameAllowed(true)
        onTriggered: {
            renameDownloadFileDlg.initialize(root.modelIds[0], 0);
            renameDownloadFileDlg.open();
        }
    }
    BaseContextMenuItem {
        text: qsTr("Move to...") + App.loc.emptyString
        visible: !App.rc.client.active
        enabled: !locked && selectedDownloadsTools.checkMoveAllowed()
        onTriggered: movingFolderDlg.open()
    }
    Action {
        text: qsTr("Delete file") + App.loc.emptyString
        enabled: !locked
        onTriggered: selectedDownloadsTools.removeCurrentDownloadsSimple(modelIds)
    }
    Action {
        text: qsTr("Remove from list") + App.loc.emptyString
        enabled: !locked
        onTriggered: selectedDownloadsTools.removeFromList(modelIds)
    }
    readonly property bool showSequentialDownload: supportsSequentialDownload
    readonly property bool showAddMirror: modelIds.length === 1 && supportsMirror
    BaseContextMenuSeparator {
        visible: showSequentialDownload || showAddMirror || supportsAddT || supportsIgnoreURatioLimit || supportsForceReann
    }
    BaseContextMenuItem {
        visible: showSequentialDownload
        enabled: !locked
        text: qsTr("Sequential Download") + App.loc.emptyString
        checkable: true
        checked: selectedDownloadsTools.sequentialDownloadChecked()
        onTriggered: selectedDownloadsTools.setSequentialDownload(checked)
    }
    BaseContextMenuItem {
        visible: showAddMirror
        enabled: !locked
        text: qsTr("Add mirror") + App.loc.emptyString
        onTriggered: addMirrorDlg.showDialog(contextMenuTools.modelId)
    }
    BaseContextMenuSeparator {}
    Action {
        enabled: modelIds.length === 1 && contextMenuTools.openDownloadPageAllowed()
        text: qsTr("Open download page") + App.loc.emptyString
        onTriggered: contextMenuTools.openDownloadPageClick()
    }
    Action {
        enabled: modelIds.length === 1
        text: qsTr("Copy link") + App.loc.emptyString
        onTriggered: contextMenuTools.copyLinkClick()
    }
    BaseContextMenuItem {
        text: qsTr("Check for update") + App.loc.emptyString
        visible: selectedDownloadsTools.canCheckForUpdate()
        onTriggered: selectedDownloadsTools.checkForUpdate()
    }
    BaseContextMenuItem {
        text: qsTr("Export selected downloads") + App.loc.emptyString
        visible: !App.rc.client.active
        onTriggered: exportDownloadsDlg.exportSelected()
    }
    BaseContextMenuSeparator {}
    BaseContextMenu {
        title: qsTr("Add Tag") + App.loc.emptyString
        enabled: tagsTools.customTags.length > 0

        Repeater {
            model: tagsTools.customTags

            delegate: BaseContextMenuItem {
                visible: !modelData.readOnly
                text: modelData.name
                checkable: true
                checked: selectedDownloadsTools.getDownloadsTagChecked(modelData.id)
                onTriggered: selectedDownloadsTools.setDownloadsTag(modelData.id, checked)
            }
        }
    }
    BaseContextMenuSeparator {
        visible: fileIntegrityVisible
    }
    BaseContextMenuItem {
        visible: fileIntegrityVisible
        enabled: !locked
        text: qsTr("File integrity") + App.loc.emptyString
        onTriggered: fileIntegrityDlg.showRequestData(contextMenuTools.modelId, 0)
    }
    BaseContextMenuSeparator {}
    BaseContextMenuItem {
        enabled: !locked && selectedDownloadsTools.setUpSchedulerAllowed()
        text: qsTr("Schedule") + App.loc.emptyString
        onTriggered: selectedDownloadsTools.setUpScheduler()
    }
    BaseContextMenuSeparator {
        visible: modelIds.length === 1
    }
    BaseContextMenuItem {
        visible: modelIds.length === 1
        enabled: !locked && canChangeUrl
        text: qsTr("Change URL") + App.loc.emptyString
        onTriggered: changeUrlDlg.showDialog(contextMenuTools.modelId)
    }
    BaseContextMenuSeparator {
    }
    BaseContextMenuItem {
        enabled: !locked && selectedDownloadsTools.convertationToMp3Allowed()
        text: qsTr("Convert to mp3") + App.loc.emptyString
        onTriggered: selectedDownloadsTools.openMp3ConverterDialog()
    }
    BaseContextMenuItem {
        enabled: !locked && selectedDownloadsTools.convertationToMp4Allowed()
        text: qsTr("Convert to mp4") + App.loc.emptyString
        onTriggered: selectedDownloadsTools.openMp4ConverterDialog()
    }
    BaseContextMenuSeparator {
    }
    BaseContextMenuItem {
        enabled: !locked && selectedDownloadsTools.allowedVirusCheck()
        text: qsTr("Perform virus check") + App.loc.emptyString
        onTriggered: selectedDownloadsTools.performVirusCheck()
    }

    Connections {
        target: appWindow
        onActiveChanged: {
            if (!appWindow.active) {
                close()
            }
        }
    }

    Component.onCompleted: {
        if (appWindow.btSupported) {
            var index = 20;
            if (btTools.item.addTAllowed()) {
                supportsAddT = true;
                root.insertItem(index++, Qt.createQmlObject('import "../bt/desktop"; AddTMenuItem {}', root));
            }
            if (btTools.item.disablePostFinishedTasksAllowed()) {
                //Don't show menu - use pause/start button in speed column instead
                /*supportsDisablePostFinishedTasks = true;
                root.insertItem(index++, Qt.createQmlObject('import "../bt/desktop"; DisableSMenuItem {}', root));*/
            }
            if (btTools.item.ignoreURatioLimitAllowed()) {
                supportsIgnoreURatioLimit = true;
                root.insertItem(index++, Qt.createQmlObject('import "../bt/desktop"; IgnoreURatioMenuItem {}', root));
            }
            if (btTools.item.forceReannounceAllowed()) {
                supportsForceReann = true;
                root.insertItem(index++, Qt.createQmlObject('import "../bt/desktop"; ForceReannMenuItem {}', root));
            }
        }
    }
}
