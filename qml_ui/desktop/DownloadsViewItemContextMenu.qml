import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.freedownloadmanager.fdm 1.0
import org.freedownloadmanager.fdm.appfeatures 1.0
import org.freedownloadmanager.fdm.abstractdownloadsui 1.0
import "BaseElements"
import "BaseElements/V2"
import "../common/Tools";

BaseContextMenu {
    id: root
    property var modelIds: []
    property bool finished
    property bool canChangeUrl
    property bool supportsMirror
    property bool batchDownload
    property bool supportsSequentialDownload: selectedDownloadsTools.sequentialDownloadAllowed()
    property bool supportsPlayAsap: selectedDownloadsTools.playAsapAllowed()
    property bool supportsAddT: false
    property bool supportsForceReann: false
    property bool supportsIgnoreURatioLimit: false
    readonly property bool endlessStream: false
    property int filesCount: 0
    property bool locked: selectedDownloadsTools.selectedDownloadsIsLocked()
    readonly property var info: modelIds.length === 1 ? App.downloads.infos.info(modelIds[0]) : null
    readonly property var error: info ? info.error : null
    readonly property bool showReportError: error && error.hasError
    readonly property bool showAllowAutoRetry: info && (showReportError || App.downloads.autoRetryMgr.isDownloadSetToAutoRetry(modelIds[0]))
    property bool threeDotsMenu: false
    property bool hideDisabledItems: threeDotsMenu

    height: Math.min(implicitHeight, appWindow.height-5*appWindow.zoom)

    DownloadsItemContextMenuTools {
        id: contextMenuTools
        modelId: root.modelIds[0]
        finished: root.finished
        singleDownload: modelIds.length === 1
    }

    transformOrigin: Menu.TopRight

    BaseContextMenuItem {
        id: finishDownloadingItem
        text: qsTr("Save and complete") + App.loc.emptyString
        visible: selectedDownloadsTools.canBeFinalized() && (enabled || !hideDisabledItems)
        enabled: !locked
        onTriggered: selectedDownloadsTools.finalizeDownloads()
    }
    BaseContextMenuSeparator {
        visible: finishDownloadingItem.visible
    }

    BaseContextMenuItem {
        id: restartItem
        text: qsTr("Restart") + App.loc.emptyString
        visible: selectedDownloadsTools.canBeRestarted() && (enabled || !hideDisabledItems)
        enabled: !locked
        onTriggered: selectedDownloadsTools.restartDownloads()
    }
    BaseContextMenuItem {
        id: openItem
        text: qsTr("Open") + App.loc.emptyString
        visible: !App.rc.client.active && (enabled || !hideDisabledItems)
        enabled: !locked && contextMenuTools.canBeOpened
        onTriggered: contextMenuTools.openClick()
    }
    BaseContextMenuItem {
        id: showInFolderItem
        enabled: modelIds.length === 1 && contextMenuTools.canBeShownInFolder
        text: qsTr("Show in folder") + App.loc.emptyString
        visible: !App.rc.client.active && (enabled || !hideDisabledItems)
        onTriggered: contextMenuTools.showInFolderClick()
    }

    BaseContextMenuSeparator {
        visible: restartItem.visible || openItem.visible || showInFolderItem.visible
    }

    BaseContextMenuItem {
        id: reportProblemItem
        visible: showReportError && (enabled || !hideDisabledItems)
        text: qsTr("Report problem") + App.loc.emptyString
        enabled: !locked
        onTriggered: contextMenuTools.reportProblem()
    }
    BaseContextMenuItem {
        id: enableAutoRetryItem
        visible: showAllowAutoRetry && (enabled || !hideDisabledItems)
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
        visible: reportProblemItem.visible || enableAutoRetryItem.visible
    }

    BaseContextMenuItem {
        id: showDownloadsItem
        text: qsTr("Show downloads") + App.loc.emptyString
        visible: modelIds.length === 1 && batchDownload
        onTriggered: downloadsViewTools.setParentDownloadIdFilter(contextMenuTools.modelId)
    }
    BaseContextMenuSeparator {
        visible: showDownloadsItem.visible
    }

    BaseContextMenuItem {
        id: chooseFilesItem
        text: qsTr("Choose files...") + App.loc.emptyString
        visible: modelIds.length === 1 && filesCount > 1
        onTriggered: bottomPanelTools.openFilesTab()
    }
    BaseContextMenuSeparator {
        visible: chooseFilesItem.visible
    }

    BaseContextMenu {
        title: qsTr("Set priority") + App.loc.emptyString
        enabled: selectedDownloadsTools.changePriorityAllowed()

        ActionGroup {
            id: downloadPriorityGroup
        }

        BaseContextMenuItem {
            text: qsTr("High") + App.loc.emptyString
            checkable: true
            checked: selectedDownloadsTools.getDownloadsPriorityChecked(AbstractDownloadsUi.DownloadPriorityHigh)
            onTriggered: selectedDownloadsTools.setDownloadsPriority(AbstractDownloadsUi.DownloadPriorityHigh)
            ActionGroup.group: downloadPriorityGroup
        }
        BaseContextMenuItem {
            text: qsTr("Normal") + App.loc.emptyString
            checkable: true
            checked: selectedDownloadsTools.getDownloadsPriorityChecked(AbstractDownloadsUi.DownloadPriorityNormal)
            onTriggered: selectedDownloadsTools.setDownloadsPriority(AbstractDownloadsUi.DownloadPriorityNormal)
            ActionGroup.group: downloadPriorityGroup
        }
        BaseContextMenuItem {
            text: qsTr("Low") + App.loc.emptyString
            checkable: true
            checked: selectedDownloadsTools.getDownloadsPriorityChecked(AbstractDownloadsUi.DownloadPriorityLow)
            onTriggered: selectedDownloadsTools.setDownloadsPriority(AbstractDownloadsUi.DownloadPriorityLow)
            ActionGroup.group: downloadPriorityGroup
        }
    }
    BaseContextMenuSeparator {}

    BaseContextMenuItem {
        id: renameFileItem
        text: qsTr("Rename file") + App.loc.emptyString
        visible: root.finished === true && root.filesCount == 1 && (enabled || !hideDisabledItems)
        enabled: !locked && selectedDownloadsTools.checkRenameAllowed(true)
        onTriggered: {
            renameDownloadFileDlg.initialize(root.modelIds[0], 0);
            renameDownloadFileDlg.open();
        }
    }
    BaseContextMenuItem {
        id: moveToItem
        text: qsTr("Move to...") + App.loc.emptyString
        visible: !App.rc.client.active && (enabled || !hideDisabledItems)
        enabled: !locked && selectedDownloadsTools.checkMoveAllowed()
        onTriggered: movingFolderDlg.open()
    }
    BaseContextMenuItem {
        id: deleteFileItem
        text: qsTr("Delete file") + App.loc.emptyString
        enabled: !locked
        visible: enabled || !hideDisabledItems
        onTriggered: selectedDownloadsTools.removeCurrentDownloadsSimple(modelIds)
    }
    BaseContextMenuItem {
        id: removeFromListItem
        text: qsTr("Remove from list") + App.loc.emptyString
        enabled: !locked
        visible: enabled || !hideDisabledItems
        onTriggered: selectedDownloadsTools.removeFromList(modelIds)
    }
    BaseContextMenuSeparator {
        visible: renameFileItem.visible || moveToItem.visible || deleteFileItem.visible || removeFromListItem.visible
    }

    BaseContextMenuItem {
        id: sequentialDownloadItem
        visible: supportsSequentialDownload && (enabled || !hideDisabledItems)
        enabled: !locked
        text: qsTr("Sequential download") + App.loc.emptyString
        checkable: true
        checked: selectedDownloadsTools.sequentialDownloadChecked()
        onTriggered: selectedDownloadsTools.setSequentialDownload(checked)
    }
    BaseContextMenuItem {
        id: playFileWhileDownloadingItem
        visible: supportsPlayAsap && (enabled || !hideDisabledItems)
        enabled: !locked
        text: qsTr("Play file while it is still downloading") + App.loc.emptyString
        checkable: true
        checked: selectedDownloadsTools.playAsapChecked()
        onTriggered: selectedDownloadsTools.setPlayAsap(checked)
    }
    BaseContextMenuItem {
        id: addMirrorItem
        visible: modelIds.length === 1 && supportsMirror && (enabled || !hideDisabledItems)
        enabled: !locked
        text: qsTr("Add mirror") + App.loc.emptyString
        onTriggered: addMirrorDlg.showDialog(contextMenuTools.modelId)
    }
    BaseContextMenuSeparator {
        visible: sequentialDownloadItem.visible || playFileWhileDownloadingItem.visible ||
                 addMirrorItem.visible ||
                 supportsAddT || supportsIgnoreURatioLimit || supportsForceReann
    }

    BaseContextMenuItem {
        id: openDownloadPageItem
        enabled: modelIds.length === 1 && contextMenuTools.openDownloadPageAllowed()
        visible: enabled || !hideDisabledItems
        text: qsTr("Open download page") + App.loc.emptyString
        onTriggered: contextMenuTools.openDownloadPageClick()
    }
    BaseContextMenuItem {
        id: copyLinkItem
        enabled: modelIds.length === 1
        visible: enabled || !hideDisabledItems
        text: qsTr("Copy link") + App.loc.emptyString
        onTriggered: contextMenuTools.copyLinkClick()
    }
    BaseContextMenuItem {
        id: checkForUpdateItem
        text: qsTr("Check for update") + App.loc.emptyString
        visible: selectedDownloadsTools.canCheckForUpdate() && (enabled || !hideDisabledItems)
        onTriggered: selectedDownloadsTools.checkForUpdate()
    }
    BaseContextMenuItem {
        id: exportSelectedDownloadsItem
        text: qsTr("Export selected downloads") + App.loc.emptyString
        visible: !App.rc.client.active && (enabled || !hideDisabledItems)
        onTriggered: exportDownloadsDlg.exportSelected()
    }
    BaseContextMenuSeparator {
        visible: openDownloadPageItem.visible || copyLinkItem.visible ||
                 checkForUpdateItem.visible || exportSelectedDownloadsItem.visible
    }

    BaseContextMenuItem {
        id: fileIntegrityItem
        visible: root.finished === true && root.filesCount == 1 && (enabled || !hideDisabledItems)
        enabled: !locked
        text: qsTr("File integrity") + App.loc.emptyString
        onTriggered: fileIntegrityDlg.showRequestData(contextMenuTools.modelId, 0)
    }
    BaseContextMenuSeparator {
        visible: fileIntegrityItem.visible
    }

    BaseContextMenuItem {
        id: scheduleItem
        enabled: !locked && selectedDownloadsTools.setUpSchedulerAllowed()
        visible: enabled || !hideDisabledItems
        text: qsTr("Schedule") + App.loc.emptyString
        onTriggered: selectedDownloadsTools.setUpScheduler()
    }
    BaseContextMenuSeparator {
        visible: scheduleItem.visible
    }

    BaseContextMenuItem {
        id: changeUrlItem
        visible: modelIds.length === 1 && (enabled || !hideDisabledItems)
        enabled: !locked && canChangeUrl
        text: qsTr("Change URL") + App.loc.emptyString
        onTriggered: changeUrlDlg.showDialog(contextMenuTools.modelId)
    }
    BaseContextMenuSeparator {
        visible: changeUrlItem.visible
    }

    BaseContextMenuItem {
        id: convertToMp3Item
        enabled: !locked && selectedDownloadsTools.convertationToMp3Allowed()
        visible: enabled || !hideDisabledItems
        text: qsTr("Convert to mp3") + App.loc.emptyString
        onTriggered: selectedDownloadsTools.openMp3ConverterDialog()
    }
    BaseContextMenuItem {
        id: convertToMp4Item
        enabled: !locked && selectedDownloadsTools.convertationToMp4Allowed()
        visible: enabled || !hideDisabledItems
        text: qsTr("Convert to mp4") + App.loc.emptyString
        onTriggered: selectedDownloadsTools.openMp4ConverterDialog()
    }
    BaseContextMenuSeparator {
        visible: convertToMp3Item.visible || convertToMp4Item.visible
    }

    BaseContextMenuItem {
        id: performVirusCheckItem
        enabled: !locked && selectedDownloadsTools.allowedVirusCheck()
        visible: enabled || !hideDisabledItems
        text: qsTr("Perform virus check") + App.loc.emptyString
        onTriggered: selectedDownloadsTools.performVirusCheck()
    }
    BaseContextMenuSeparator {
        visible: performVirusCheckItem.visible
    }

    BaseContextMenu {
        id: addTagMenu

        title: qsTr("Add tag") + App.loc.emptyString

        TagsMenuHelper {
            menu: addTagMenu
            tags: tagsTools.customTags
        }

        BaseContextMenuSeparator {
            visible: appWindow.uiver !== 1 &&
                     tagsTools.customTags.length > 0
        }

        AddNewTagMenuItem {
            visible: appWindow.uiver !== 1
            anchors.leftMargin: addTagMenu.leftPadding
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

    Component.onCompleted: {
        if (appWindow.btSupported) {
            let downloadId = modelIds.length === 1 ?
                    "downloadId: " + modelIds[0] :
                    "";
            var index = 21;
            if (btTools.item.addTAllowed()) {
                supportsAddT = true;
                root.insertItem(index++, Qt.createQmlObject('import "../bt/desktop"; AddTMenuItem {%1}'.arg(downloadId), root));
            }
            if (btTools.item.disablePostFinishedTasksAllowed()) {
                if (appWindow.uiver === 1) {
                    //Don't show menu - use pause/start button in speed column instead
                }
                else if (threeDotsMenu) {
                    root.insertItem(index++, Qt.createQmlObject('import "../bt/desktop"; DisableSMenuItem {%1}'.arg(downloadId), root));
                }
            }
            if (btTools.item.ignoreURatioLimitAllowed()) {
                supportsIgnoreURatioLimit = true;
                root.insertItem(index++, Qt.createQmlObject('import "../bt/desktop"; IgnoreURatioMenuItem {%1}'.arg(downloadId), root));
            }
            if (btTools.item.forceReannounceAllowed()) {
                supportsForceReann = true;
                root.insertItem(index++, Qt.createQmlObject('import "../bt/desktop"; ForceReannMenuItem {%1}'.arg(downloadId), root));
            }
        }
    }
}
