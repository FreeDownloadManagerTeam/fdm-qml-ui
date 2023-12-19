import QtQuick 2.0
import org.freedownloadmanager.fdm 1.0
import org.freedownloadmanager.fdm.abstractdownloadsui 1.0
import org.freedownloadmanager.fdm.dmcoresettings 1.0
import org.freedownloadmanager.fdm.appsettings 1.0

Item {

    property double currentDownloadId: -1

    property var checkedIds: []

    property int checkedDownloadsCount: checkedIds.length
    property int allDownloadsChecked: App.downloads.model.allCheckState

    property bool checkedDownloadsToStartExist: false;
    property bool checkedDownloadsToStopExist: false;

    property bool downloadsToStartExist: App.downloads.tracker.hasDownloadsToStart
    property bool downloadsToStopExist: App.downloads.tracker.hasDownloadsToStop

    property var draggableCheckedIds: []
    property var draggableCheckedFilesDragUriList: []

    signal modelCheckedChanged(double model_id)
    signal modelRunningChanged(double model_id)
    signal modelFinishedChanged(double model_id)
    signal modelErrorChanged(double model_id)

    onModelCheckedChanged: updateState();
    onModelFinishedChanged: updateState();
    onModelRunningChanged: updateState();
    onModelErrorChanged: updateState();

    property QtObject currentDownloadsListView: null

    property int shiftSelectStartIndex: -1

    Component.onCompleted: {
        App.downloads.model.currentDownloadId = Qt.binding(function() {return currentDownloadId;});
        uiReadyTools.onReady(onComponentReady);
    }

    Connections {
        target: App.downloads.infos
        onAdded: function(ids) {
            if (ids.length && ids[0])
                selectDownloadItemById(ids[0]);
            updateState();
        }
    }

    Connections {
        target: App.downloads.model
        onRemovedFromList: function(ids) {
            if (ids.indexOf(currentDownloadId) >= 0) {
                resetShiftSelectStartIndex();
                currentDownloadId = -1;
            }
            updateState();
        }
    }

    Connections {
        target: downloadsViewTools
        onDownloadsTitleFilterChanged: setCurrentIdToFirstItemInList()
        onDownloadsStatesFilterChanged: setCurrentIdToFirstItemInList()
        onDownloadsParentIdFilterChanged: setCurrentIdToFirstItemInList()
        onDownloadsTagFilterChanged: setCurrentIdToFirstItemInList()
    }

    function setCurrentIdToFirstItemInList() {
        resetShiftSelectStartIndex();
        if (App.downloads.model.rowCount > 0) {
            currentDownloadId = App.downloads.model.idByIndex(0);
        } else {
            currentDownloadId = -1;
        }
        updateState();
    }

    Timer {
        id: changedTimer
        interval: 100;
        running: false;
        repeat: false
        onTriggered: {
            checkedIds = App.downloads.model.checkedIds();
            checkedDownloadsToStartExist = App.downloads.model.hasCheckedDownloadsToStart();
            checkedDownloadsToStopExist = App.downloads.model.hasCheckedDownloadsToStop();
            updateDraggableState();
        }
    }

    function updateDraggableState()
    {
        let ids = [];
        let uriList = [];

        for (let i = 0; i < checkedIds.length; ++i)
        {
            let id = checkedIds[i];
            let info = App.downloads.infos.info(id);
            if (!info)
                continue;
            let list = info.filesDragUriList;
            if (list && list.length)
            {
                ids.push(id);
                uriList = uriList.concat(list);
            }
        }

        draggableCheckedIds = ids;
        draggableCheckedFilesDragUriList = uriList;
    }

    function onComponentReady()
    {
        if (App.downloads.model.rowCount > 0) {
            currentDownloadId = App.downloads.model.idByIndex(0);
        }
    }

    function updateState()
    {
        changedTimer.restart();
    }

    function startCheckedDownloads() {
        startByIds(App.downloads.model.checkedIdsToStart());
    }

    function stopCheckedDownloads() {
        let ids = App.downloads.model.checkedIdsToStop();
        stopDownloads(ids);
    }

    function checkDownloadsResume(ids) {
        let noResumeIds = [];
        if (ids.length > 0) {
            var download = null;
            for (var i = 0; i < ids.length; i++) {
                download = App.downloads.infos.info(ids[i]);
                if (!download.finished && download.resumeSupport == AbstractDownloadsUi.DownloadResumeSupportAbsent) {
                    noResumeIds.push(ids[i]);
                }
            }
        }

        if (noResumeIds.length) {
            appWindow.stopDownload(noResumeIds);
        }

        return ids.filter( el => !noResumeIds.includes( el ) );
    }

    function restartCheckedDownloads() {
        var ids = getCurrentDownloadIds();
        if (ids.length > 0) {
            var download = null;
            for (var i = 0; i < ids.length; i++) {
                download = App.downloads.infos.info(ids[i]);
                if (!download.finished && (download.error.hasError || download.missingFiles) && (download.flags & AbstractDownloadsUi.SupportsRestart) != 0) {
                    App.downloads.mgr.restartDownload(ids[i]);
                }
            }
        }
    }

    function copyCurrentUrl()
    {
        if (selectedDownloadsTools.currentDownloadId >= 0) {
            App.clipboard.text = App.downloads.infos.info(selectedDownloadsTools.currentDownloadId).resourceUrl
        }
    }

    function removeCheckedFromList()
    {
        var ids = getCurrentDownloadIds();
        removeFromList(ids);
    }

    function setDownloadsPriority(priority)
    {
        var ids = getCurrentDownloadIds();
        if (ids.length > 0) {
            for (var i = 0; i < ids.length; i++) {
                App.downloads.infos.info(ids[i]).priority = priority;
            }
        }
    }

    function getDownloadsPriorityChecked(priority)
    {
        var checked = true;
        var ids = getCurrentDownloadIds();
        if (ids.length > 0) {
            for (var i = 0; i < ids.length; i++) {
                if (App.downloads.infos.info(ids[i]).priority != priority) {
                    checked = false;
                    break;
                }
            }
        }
        return checked;
    }

    function setDownloadsTag(tagId, setTag)
    {
        var ids = getCurrentDownloadIds();
        if (ids.length > 0) {
            tagsTools.changeDownloadsTag(ids, tagId, setTag);
        }
    }

    function getDownloadsTagChecked(tagId)
    {
        var ids = getCurrentDownloadIds();
        if (ids.length > 0) {
            for (var i = 0; i < ids.length; i++) {
                var itemTags = App.downloads.tags.downloadTags(ids[i]);
                if (!itemTags.includes(tagId)) {
                    return false;
                }
            }
        }
        return true;
    }

    function changePriorityAllowed()
    {
        var allowed = true;
        var ids = getCurrentDownloadIds();
        var download = null;
        if (ids.length > 0) {
            for (var i = 0; i < ids.length; i++) {
                download = App.downloads.infos.info(ids[i]);
                if (download.finished) {
                    allowed = false;
                    break;
                }
            }
        }

        return allowed;
    }

    function checkFilesLoAllowed()
    {
        var allowed = true;
        if (checkedDownloadsCount > 0) {
            allowed = App.downloads.model.hasCheckedDownloadsToPerformFilesLo();
        } else {
            allowed = App.downloads.logics.isFilesLoAllowed(currentDownloadId);
        }
        return allowed;
    }

    function checkMoveAllowed()
    {
        return checkFilesLoAllowed();
    }

    function checkRenameAllowed(wholeDownload)
    {
        if (checkedDownloadsCount > 0)
        {
            if (checkedDownloadsCount > 1 ||
                    !App.downloads.model.isChecked(currentDownloadId))
            {
                return false;
            }
        }
        let info = App.downloads.infos.info(currentDownloadId);
        if (wholeDownload && info.filesCount > 1)
            return false;
        return info.finished && checkFilesLoAllowed();
    }

    function sequentialDownloadAllowed()
    {
        var allowed = true;
        var ids = getCurrentDownloadIds();
        var download = null;
        if (ids.length > 0) {
            for (var i = 0; i < ids.length; i++) {
                download = App.downloads.infos.info(ids[i]);
                if (download.finished || !(download.flags & AbstractDownloadsUi.SupportsSequentialDownload)) {
                    allowed = false;
                    break;
                }
            }
        }
        return allowed;
    }

    function sequentialDownloadChecked()
    {
        var checked = true;
        var ids = getCurrentDownloadIds();
        var download = null;
        if (ids.length > 0) {
            for (var i = 0; i < ids.length; i++) {
                download = App.downloads.infos.info(ids[i]);
                if (!download.sequentialDownload) {
                    checked = false;
                    break;
                }
            }
        }
        return checked;
    }

    function setSequentialDownload(checked)
    {
        var ids = getCurrentDownloadIds();
        if (ids.length > 0) {
            for (var i = 0; i < ids.length; i++) {
                App.downloads.infos.info(ids[i]).sequentialDownload = checked;
            }
        }
    }

    function canBeRestarted()
    {
        var allowed = true;
        var ids = getCurrentDownloadIds();
        var download = null;
        if (ids.length > 0) {
            for (var i = 0; i < ids.length; i++) {
                download = App.downloads.infos.info(ids[i]);
                if (!(!download.finished && (download.error.hasError || download.missingFiles)
                        && (download.flags & AbstractDownloadsUi.SupportsRestart) != 0
                        && download.lockReason == "" && !download.stopping)) {
                    allowed = false;
                    break;
                }
            }
        }
        return allowed;
    }

    function restartDownloads()
    {
        var ids = getCurrentDownloadIds();
        if (ids.length > 0) {
            for (var i = 0; i < ids.length; i++) {
                App.downloads.mgr.restartDownload(ids[i]);
            }
        }
    }

    function canBeFinalized()
    {
        var allowed = true;
        var ids = getCurrentDownloadIds();
        var download = null;
        if (ids.length > 0)
        {
            for (var i = 0; i < ids.length; i++)
            {
                download = App.downloads.infos.info(ids[i]);
                if (download.finished || !(download.flags & AbstractDownloadsUi.EndlessStream) ||
                        download.lockReason || download.stopping)
                {
                    allowed = false;
                    break;
                }
            }
        }
        return allowed;
    }

    function finalizeDownloads()
    {
        var ids = getCurrentDownloadIds();
        if (ids.length > 0) {
            for (var i = 0; i < ids.length; i++) {
                App.downloads.mgr.finalizeDownload(ids[i]);
            }
        }
    }

    function canCheckForUpdate()
    {
        var allowed = true;
        var ids = getCurrentDownloadIds();
        var download = null;
        if (ids.length > 0) {
            for (var i = 0; i < ids.length; i++) {
                download = App.downloads.infos.info(ids[i]);
                if (!(download.finished
                      && (download.flags & AbstractDownloadsUi.CanDetectRemoteResourceChanges) != 0
                      && download.lockReason == "")) {
                    allowed = false;
                    break;
                }
            }
        }
        return allowed;
    }

    function checkForUpdate()
    {
        var ids = getCurrentDownloadIds();

        if (ids.length > 0) {
            for (var i = 0; i < ids.length; i++) {
                App.downloads.mgr.checkIfRemoteResourceChanged(ids[i]);
            }
        }
    }

    function stopDownloads(ids) {
        ids = ids.filter(el => !downloadIsLocked(el));
        ids = checkDownloadsResume(ids);
        if (ids.length) {
            stopByIds(ids);
        }
    }

    function startByIds(ids)
    {
        ids = ids.filter(el => !downloadIsLocked(el));
        for (var i = 0; i < ids.length; i++) {
            App.downloads.mgr.startDownload(ids[i], true);
        }
    }

    function stopByIds(ids)
    {
        ids = ids.filter(el => !downloadIsLocked(el));
        for (var i = 0; i < ids.length; i++) {
            App.downloads.mgr.stopDownload(ids[i], false);
        }
    }

    function removeFromList(ids)
    {
        ids = ids.filter(el => !downloadIsLocked(el));
        if (ids.length > 0) {
            setCurrentNearbyItem(ids);
            App.downloads.mgr.removeDownloads(ids, false, false);
        }
    }

    function removeFromDisk(ids)
    {
        ids = ids.filter(el => !downloadIsLocked(el));
        if (ids.length > 0) {
            setCurrentNearbyItem(ids);
            App.downloads.mgr.removeDownloads(ids, true, App.downloads.mgr.supportsMoveFilesToTrash());
        }
    }

    function setCurrentNearbyItem(ids)
    {
        resetShiftSelectStartIndex();
        var download_id, i;
        if (ids.indexOf(currentDownloadId) >= 0) {
            var current_index = App.downloads.model.indexById(currentDownloadId);
            for (i = current_index + 1; i < downloadsViewTools.downloadsRowsCount; i++) {
                download_id = App.downloads.model.idByIndex(i);
                if (download_id >= 0 && ids.indexOf(download_id) < 0) {
                    currentDownloadId = download_id;
                    return;
                }
            }
            for (i = current_index - 1; i > 0; i--) {
                download_id = App.downloads.model.idByIndex(i);
                if (download_id >= 0 && ids.indexOf(download_id) < 0) {
                    currentDownloadId = download_id;
                    return;
                }
            }
        }
    }

    function downloadMousePressed(download_id, mouse)
    {
        var download_is_checked = App.downloads.model.isChecked(download_id);

        var clear_checked_for_all = true;
        if (download_is_checked && mouse.button === Qt.RightButton)
            clear_checked_for_all = false;
        if (mouse.modifiers & Qt.ControlModifier)
            clear_checked_for_all = false;

        if (clear_checked_for_all) {
            App.downloads.model.checkAll(false);
        }

        if (mouse.modifiers & Qt.ShiftModifier && currentDownloadId) {
            setShiftSelectStartIndex();
            var new_index = App.downloads.model.indexById(download_id);
            App.downloads.model.setCheckedRange(shiftSelectStartIndex, new_index, true);
        } else {
            resetShiftSelectStartIndex();
            if (mouse.modifiers & Qt.ControlModifier && mouse.button !== Qt.RightButton) {
                App.downloads.model.setChecked(download_id, !App.downloads.model.isChecked(download_id));
            }
        }
        currentDownloadId = download_id;
    }

    function selectedByMouse(startId, endId) {
        currentDownloadId = startId;
        resetShiftSelectStartIndex();
        setShiftSelectStartIndex();
        var new_index = App.downloads.model.indexById(endId);
        App.downloads.model.checkAll(false);
        App.downloads.model.setCheckedRange(shiftSelectStartIndex, new_index, true);
    }

    function resetSelecting() {
        App.downloads.model.checkAll(false);
        resetShiftSelectStartIndex();
    }

    function changeItemChecked(download_id, mouse) {
        if (mouse.modifiers & Qt.ShiftModifier && currentDownloadId) {
            downloadMousePressed(download_id, mouse)
        } else {
            resetShiftSelectStartIndex();
            App.downloads.model.setChecked(download_id, !App.downloads.model.isChecked(download_id));
            currentDownloadId = download_id;
        }
    }

    function resetShiftSelectStartIndex() {
        shiftSelectStartIndex =  -1
    }

    function setShiftSelectStartIndex() {
        if (shiftSelectStartIndex < 0) {
            shiftSelectStartIndex = App.downloads.model.indexById(currentDownloadId);
        }
    }

    function selectDownloadItemById(download_id)
    {
        App.downloads.model.checkAll(false);
        resetShiftSelectStartIndex();
        var info = App.downloads.infos.info(download_id);
        if (info.parentId !== App.downloads.model.parentDownloadIdFilter &&
                (info.parentId > 0 || App.downloads.model.parentDownloadIdFilter > 0))
        {
            if (info.parentId !== -1)
                downloadsViewTools.setParentDownloadIdFilter(info.parentId);
            else
                downloadsViewTools.resetParentDownloadIdFilter();
        }
        currentDownloadId = download_id;
    }

    function getCurrentDownloadIds()
    {
        var current_ids = [];
        if (checkedDownloadsCount > 0) {
            current_ids = checkedIds;
        } else if (currentDownloadId > 0) {
            current_ids = [ currentDownloadId ];
        }
        return current_ids;
    }

    onCurrentDownloadIdChanged: {
        currentDownloadsVisible();
    }

    function registerListView(list_view)
    {
        currentDownloadsListView = list_view;
        currentDownloadsVisible();
    }

    function unregisterListView()
    {
        currentDownloadsListView = null;
    }

    function currentDownloadsVisible(iteration)
    {
        iteration = iteration || 0;
        if (currentDownloadsListView && currentDownloadId) {
            var current_index = App.downloads.model.indexById(currentDownloadId);
            if (current_index < 0) {
                if (iteration < 10) {
                    currentDownloadsVisibleTimer.iteration = (iteration + 1);
                    currentDownloadsVisibleTimer.restart();
                }
            } else {
                currentDownloadsListView.positionViewAtIndex(current_index, ListView.Contain);
            }
        }
    }

    Timer {
        id: currentDownloadsVisibleTimer
        property int iteration: 0
        interval: 100;
        running: false;
        repeat: false
        onTriggered: currentDownloadsVisible(iteration)
    }

    function navigateToEnd(increment_page, shift_modifier)
    {
        if (currentDownloadsListView && currentDownloadsListView.count) {
            navigateToIndex( currentDownloadsListView.count - 1, shift_modifier);
        }
    }

    function navigateToHome(increment_page, shift_modifier)
    {
        navigateToIndex(0, shift_modifier);
    }

    function navigateToNearbyPage(increment_page, shift_modifier)
    {
        var item_height = 40;
        var count_items_on_page = parseInt(currentDownloadsListView.height/item_height);
        navigateToNearbyItem(increment_page*count_items_on_page, shift_modifier);
    }

    function navigateToNearbyItem(index_increment, shift_modifier)
    {
        var current_index = App.downloads.model.indexById(currentDownloadId);
        if (current_index >= 0) {
            var new_index = current_index + index_increment;
            navigateToIndex(new_index, shift_modifier);
        }
    }

    function navigateToIndex(index, shift_modifier)
    {
        if (currentDownloadsListView && currentDownloadsListView.count && currentDownloadId) {
            var current_index = App.downloads.model.indexById(currentDownloadId);
            if (current_index >= 0) {
                var new_index = Math.max(index, 0);
                new_index = Math.min(new_index, currentDownloadsListView.count - 1);

                var new_download_id = App.downloads.model.idByIndex(new_index);
                if (new_download_id >= 0) {
                    if (shift_modifier) {
                        setShiftSelectStartIndex();
                        App.downloads.model.checkAll(false);
                        App.downloads.model.setCheckedRange(shiftSelectStartIndex, new_index, true);
                    } else {
                        resetShiftSelectStartIndex();
                    }
                    currentDownloadId = new_download_id;
                }
            }
        }
    }

    function checkAll(check)
    {
        App.downloads.model.checkAll(check);
    }

    function removeCurrentDownloads()
    {
        var ids = getCurrentDownloadIds();
        ids = ids.filter(el => !downloadIsLocked(el));
        if (ids.length > 0) {
            if (downloadsViewTools.showingDownloadsWithMissingFilesOnly)
                removeFromList(ids);
            else
                deleteDownloadsDlg.removeAction(ids);
        }
    }

    function removeCurrentDownloadsSimple()
    {
        var ids = getCurrentDownloadIds();
        ids = ids.filter(el => !downloadIsLocked(el));
        if (ids.length > 0) {
            deleteDownloadsDlgSimple.removeAction(ids);
        }
    }

    function moveCurrentDownloads(path)
    {
        var ids = getCurrentDownloadIds();
        moveDownloads(ids, path);
    }

    function moveDownloads(ids, path)
    {
        ids = ids.filter(el => App.downloads.logics.isFilesLoAllowed(el));
        for (var i = 0; i < ids.length; i++) {
            App.downloads.moveFilesMgr.moveFiles(ids[i], path);
        }
        checkAll(false);
    }

    function setUpSchedulerAllowed()
    {
        var allowed = true;
        var ids = getCurrentDownloadIds();
        var download = null;
        if (ids.length > 0) {
            for (var i = 0; i < ids.length; i++) {
                download = App.downloads.infos.info(ids[i]);
                if (download.finished || download.error.hasError) {
                    allowed = false;
                    break;
                }
            }
        }
        return allowed;
    }

    function setUpScheduler()
    {
        var ids = getCurrentDownloadIds();
        openSchedulerDialog(ids);
    }

    function openSchedulerDialog(ids)
    {
        schedulerDlg.setUpSchedulerAction(ids);
    }

    function convertationToMp3Allowed() {
        var allowed = true;
        var ids = getCurrentDownloadIds();
        var download = null;
        if (ids.length > 0) {
            for (var i = 0; i < ids.length; i++) {
                download = App.downloads.infos.info(ids[i]);
                if (!download.finished || download.error.hasError || download.missingFiles || download.missingStorage
                    || !((download.allFilesTypes
                          & ((1 << AbstractDownloadsUi.VideoFile) | (1 << AbstractDownloadsUi.AudioFile))) != 0)) {
                    allowed = false;
                    break;
                }
            }
        }
        return allowed;
    }

    function convertationToMp4Allowed() {
        var allowed = true;
        var ids = getCurrentDownloadIds();
        var download = null;
        if (ids.length > 0) {
            for (var i = 0; i < ids.length; i++) {
                download = App.downloads.infos.info(ids[i]);
                if (!download.finished || download.error.hasError || download.missingFiles || download.missingStorage
                    || !((download.allFilesTypes
                          & (1 << AbstractDownloadsUi.VideoFile)) != 0)) {
                    allowed = false;
                    break;
                }
                var hasNonMp4Video = false;
                for (var fi = 0; fi < download.filesCount; ++fi) {
                    var fileInfo = download.fileInfo(fi);
                    if (fileInfo.fileType == AbstractDownloadsUi.VideoFile &&
                            fileInfo.suffix.toUpperCase() !== "MP4") {
                        hasNonMp4Video = true;
                        break;
                    }
                }
                if (!hasNonMp4Video) {
                    allowed = false;
                    break;
                }
            }
        }
        return allowed;
    }

    function openMp3ConverterDialog()
    {
        var ids = getCurrentDownloadIds();
        mp3ConverterDlg.open(ids, []);
    }

    function openMp4ConverterDialog()
    {
        var ids = getCurrentDownloadIds();
        mp4ConverterDlg.open(ids, []);
    }

    function quickLookFile() {
        if (currentDownloadId) {
            var download = App.downloads.infos.info(currentDownloadId);
            if (download) {
                App.tools.quickLookFile(download.hasChildDownloads ? download.destinationPath : download.destinationPath + '/' + download.title);
            }
        }
    }

    function isAntivirusSettingsOk()
    {
        return App.settings.dmcore.value(DmCoreSettings.AntivirusUid) != "" ||
                (App.settings.dmcore.value(DmCoreSettings.AntivirusPath).length > 0
                   && App.settings.isValidCustomAntivirusArgs(App.settings.dmcore.value(DmCoreSettings.AntivirusArgs)) == '');
    }

    function allowedVirusCheck() {
        // we have no UI to setup antivirus settings on a remote machine
        if (App.rc.client.active && !isAntivirusSettingsOk())
            return false;

        var allowed = true;
        var ids = getCurrentDownloadIds();
        var download = null;
        for (var i = 0; i < ids.length; i++) {
            download = App.downloads.infos.info(ids[i]);
            if (!download.finished || download.missingFiles || download.missingStorage) {
                allowed = false;
                break;
            }
        }
        return allowed;
    }

    function performVirusCheck() {
        if (isAntivirusSettingsOk()) {
            var ids = getCurrentDownloadIds();
            App.downloads.mgr.performVirusCheck(ids);
        } else {
            antivirusSettingsDialog.open();
        }
    }

    function downloadIsLocked(id)
    {
        var download = App.downloads.infos.info(id);
        return download && download.lockReason != "";
    }

    function selectedDownloadsIsLocked()
    {
        var ids = getCurrentDownloadIds();
        return ids.findIndex(el => downloadIsLocked(el)) !== -1;
    }

    Connections
    {
        target: App
        onHighlightDownloads: selectedDownloadsTools.selectDownloadItemById(ids[0])
    }
}
