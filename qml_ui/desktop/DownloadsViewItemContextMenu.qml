import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.freedownloadmanager.fdm
import org.freedownloadmanager.fdm.appfeatures
import org.freedownloadmanager.fdm.abstractdownloadsui
import "BaseElements"
import "BaseElements/V2"
import "../common/Tools"

BaseContextMenu {
    id: root
    property var modelIds: []
    property bool supportsAddT: false
    property bool supportsForceReann: false
    property bool supportsIgnoreURatioLimit: false
    readonly property var info: modelIds.length === 1 ? App.downloads.infos.info(modelIds[0]) : null
    readonly property var error: info ? info.error : null
    readonly property bool showReportError: error && error.hasError
    readonly property bool showAllowAutoRetry: info && (showReportError || App.downloads.autoRetryMgr.isDownloadSetToAutoRetry(modelIds[0]))
    property bool threeDotsMenu: false
    property bool hideDisabledItems: threeDotsMenu

    height: Math.min(implicitHeight, appWindow.height-5*appWindow.zoom)

    DownloadsItemsTools {
        id: tools
        ids: modelIds
    }

    DownloadsItemContextMenuTools {
        id: contextMenuTools
        modelId: root.modelIds[0]
        finished: tools.finished
        singleDownload: modelIds.length === 1
    }

    transformOrigin: Menu.TopRight

    BaseContextMenuItem {
        id: finishDownloadingItem
        text: qsTr("Save and complete") + App.loc.emptyString
        visible: tools.canBeFinalized && (enabled || !hideDisabledItems)
        enabled: !tools.locked
        onTriggered: tools.finalizeDownloads()
    }
    BaseContextMenuSeparator {
        visible: finishDownloadingItem.visible
    }

    BaseContextMenuItem {
        id: restartItem
        text: qsTr("Restart") + App.loc.emptyString
        visible: tools.canBeRestarted && (enabled || !hideDisabledItems)
        enabled: !tools.locked
        onTriggered: tools.restartDownloads()
    }
    BaseContextMenuItem {
        id: openItem
        text: qsTr("Open") + App.loc.emptyString
        visible: !App.rc.client.active && (enabled || !hideDisabledItems)
        enabled: !tools.locked && contextMenuTools.canBeOpened
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
        enabled: !tools.locked
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
        visible: tools.ids.length === 1 && tools.info.hasChildDownloads
        onTriggered: downloadsViewTools.setParentDownloadIdFilter(contextMenuTools.modelId)
    }
    BaseContextMenuSeparator {
        visible: showDownloadsItem.visible
    }

    BaseContextMenuItem {
        id: chooseFilesItem
        text: qsTr("Choose files...") + App.loc.emptyString
        visible: tools.ids.length === 1 && tools.info.filesCount > 1
        onTriggered: bottomPanelTools.openFilesTab()
    }
    BaseContextMenuSeparator {
        visible: chooseFilesItem.visible
    }

    BaseContextMenu {
        title: qsTr("Set priority") + App.loc.emptyString
        enabled: tools.canChangePriority

        ActionGroup {
            id: downloadPriorityGroup
        }

        BaseContextMenuItem {
            text: uicore.priorityText(AbstractDownloadsUi.DownloadPriorityHigh) + App.loc.emptyString
            checkable: true
            checked: tools.highPriority
            onTriggered: tools.setDownloadsPriority(AbstractDownloadsUi.DownloadPriorityHigh)
            ActionGroup.group: downloadPriorityGroup
        }
        BaseContextMenuItem {
            text: uicore.priorityText(AbstractDownloadsUi.DownloadPriorityNormal) + App.loc.emptyString
            checkable: true
            checked: tools.normalPriority
            onTriggered: tools.setDownloadsPriority(AbstractDownloadsUi.DownloadPriorityNormal)
            ActionGroup.group: downloadPriorityGroup
        }
        BaseContextMenuItem {
            text: uicore.priorityText(AbstractDownloadsUi.DownloadPriorityLow) + App.loc.emptyString
            checkable: true
            checked: tools.lowPriority
            onTriggered: tools.setDownloadsPriority(AbstractDownloadsUi.DownloadPriorityLow)
            ActionGroup.group: downloadPriorityGroup
        }
    }
    BaseContextMenuSeparator {}

    BaseContextMenuItem {
        id: renameFileItem
        text: qsTr("Rename file") + App.loc.emptyString
        visible: tools.ids.length === 1 && tools.finished && tools.info.filesCount === 1 && (enabled || !hideDisabledItems)
        enabled: !tools.locked && tools.canRename
        onTriggered: {
            renameDownloadFileDlg.initialize(root.modelIds[0], 0);
            renameDownloadFileDlg.open();
        }
    }
    BaseContextMenuItem {
        id: moveToItem
        text: qsTr("Move to...") + App.loc.emptyString
        visible: !App.rc.client.active && (enabled || !hideDisabledItems)
        enabled: !tools.locked && tools.canMove
        onTriggered: movingFolderDlg.openForIds(tools.ids)
    }
    BaseContextMenuItem {
        id: deleteFileItem
        text: qsTr("Delete file") + App.loc.emptyString
        enabled: !tools.locked
        visible: enabled || !hideDisabledItems
        onTriggered: deleteDownloadsDlgSimple.removeAction(tools.ids)
    }
    BaseContextMenuItem {
        id: removeFromListItem
        text: qsTr("Remove from list") + App.loc.emptyString
        enabled: !tools.locked
        visible: enabled || !hideDisabledItems
        onTriggered: selectedDownloadsTools.removeFromList(tools.ids)
    }
    BaseContextMenuSeparator {
        visible: renameFileItem.visible || moveToItem.visible || deleteFileItem.visible || removeFromListItem.visible
    }

    BaseContextMenuItem {
        id: sequentialDownloadItem
        visible: tools.supportsSequentialDownload && (enabled || !hideDisabledItems)
        enabled: !tools.locked
        text: qsTr("Sequential download") + App.loc.emptyString
        checkable: true
        checked: tools.sequentialDownload
        onTriggered: tools.setSequentialDownload(checked)
    }
    BaseContextMenuItem {
        id: playFileWhileDownloadingItem
        visible: tools.supportsPlayAsap && (enabled || !hideDisabledItems)
        enabled: !tools.locked
        text: qsTr("Play file while it is still downloading") + App.loc.emptyString
        checkable: true
        checked: tools.playAsap
        onTriggered: tools.setPlayAsap(checked)
    }
    BaseContextMenuItem {
        id: addMirrorItem
        visible: tools.ids.length === 1 && (tools.info.flags & AbstractDownloadsUi.SupportsMirrors) && (enabled || !hideDisabledItems)
        enabled: !tools.locked
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
        visible: tools.canCheckForUpdate && (enabled || !hideDisabledItems)
        onTriggered: tools.checkForUpdate()
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
        visible: tools.ids.length === 1 && tools.finished && tools.info.filesCount === 1 && (enabled || !hideDisabledItems)
        enabled: !tools.locked
        text: qsTr("File integrity") + App.loc.emptyString
        onTriggered: fileIntegrityDlg.showRequestData(contextMenuTools.modelId, 0)
    }
    BaseContextMenuSeparator {
        visible: fileIntegrityItem.visible
    }

    BaseContextMenuItem {
        id: scheduleItem
        enabled: !tools.locked && tools.canSchedule
        visible: enabled || !hideDisabledItems
        text: qsTr("Schedule") + App.loc.emptyString
        onTriggered: schedulerDlg.setUpSchedulerAction(tools.ids)
    }
    BaseContextMenuSeparator {
        visible: scheduleItem.visible
    }

    BaseContextMenuItem {
        id: changeUrlItem
        visible: tools.ids.length === 1 && (enabled || !hideDisabledItems)
        enabled: !tools.locked && (tools.info.flags & AbstractDownloadsUi.AllowChangeSourceUrl)
        text: qsTr("Change URL") + App.loc.emptyString
        onTriggered: changeUrlDlg.showDialog(contextMenuTools.modelId)
    }
    BaseContextMenuSeparator {
        visible: changeUrlItem.visible
    }

    BaseContextMenuItem {
        id: convertToMp3Item
        enabled: !tools.locked && tools.canConvertToMp3
        visible: enabled || !hideDisabledItems
        text: qsTr("Convert to mp3") + App.loc.emptyString
        onTriggered: mp3ConverterDlg.open(tools.ids, [])
    }
    BaseContextMenuItem {
        id: convertToMp4Item
        enabled: !tools.locked && tools.canConvertToMp4
        visible: enabled || !hideDisabledItems
        text: qsTr("Convert to mp4") + App.loc.emptyString
        onTriggered: mp4ConverterDlg.open(tools.ids, [])
    }
    BaseContextMenuSeparator {
        visible: convertToMp3Item.visible || convertToMp4Item.visible
    }

    BaseContextMenuItem {
        id: performVirusCheckItem
        enabled: !tools.locked && tools.canPerformVirusCheck
        visible: enabled || !hideDisabledItems
        text: qsTr("Perform virus check") + App.loc.emptyString
        onTriggered: {
            if (DownloadsTools.isAntivirusSettingsOk())
                App.downloads.mgr.performVirusCheck(tools.ids);
            else
                antivirusSettingsDialog.open();
        }
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
            downloadsItemsTools: tools
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
            let index = 0;
            for (let i = 0; i < root.count; ++i) {
                if (root.itemAt(i) == sequentialDownloadItem) {
                    index = i;
                    break;
                }
            }
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
