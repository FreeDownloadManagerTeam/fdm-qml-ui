import QtQuick 2.0
import org.freedownloadmanager.fdm 1.0
import org.freedownloadmanager.fdm.abstractdownloadsui 1.0

Item {
    property double itemId
    property var item
    property bool finished: !item ? false : item.finished
    property bool running: !item ? false : item.running || item.buildingFinalDownload
    property bool stopping: !item ? false : !!item.stopping
    property bool autoStartAllowed: !item ? false : item.autoStartAllowed
    property bool postFinishedTasksAllowed: !item ? false : (autoStartAllowed && !item.disablePostFinishedTasks)
    property var downloadError: (item && item.error && item.error.hasError) ? item.error : null
    property bool missingFiles: !item ? false : item.missingFiles
    property bool missingStorage: !item ? false : item.missingStorage
    property bool finalDownload: !item ? false : item.finalDownload
    property bool hasPostFinishedTasks: !item ? false : item.hasPostFinishedTasks
    property int flags: !item ? 0 : item.flags
    property string moduleUid: !item ? "" : item.moduleUid
    property string state: !item ? "" : item.state
    property bool hasDetails: !!item && item.details !== undefined

    property bool checkingFiles: (!item || !item.checkingFiles) ? false : item.checkingFiles
    property int checkingFilesProgress: !item ? -1 : parseInt(item.checkingFilesProgress)

    property bool mergingFiles: (!item || !item.mergingFiles) ? false : item.mergingFiles
    property int mergingFilesProgress: !item ? -1 : parseInt(item.mergingFilesProgress)

    property string lockReason: !item ? "" : item.lockReason
    property bool loRunning: !item ? false : item.loRunning
    property int loProgress: loRunning ? item.loProgress : -1
    property bool loError: (!item || !item.lockReason) ? false : item.loError.hasError
    property bool loAbortable: lockReason === "convertFilesToMp3" || lockReason == "convertFilesToMp4"

    property bool performingLo: lockReason !== ""
    property string loUiText: (lockReason === "moveFiles" ? qsTr("Moving") :
                               lockReason === "virusCheck" ? qsTr("Checking for viruses") :
                               lockReason === "convertFilesToMp3" ? qsTr("Converting to mp3") :
                               lockReason === "convertFilesToMp4" ? qsTr("Converting to mp4") :
                               lockReason === "calculateHash" ? qsTr("Calculating hash") : "") + App.loc.emptyString
    property string loUiTextWithProgress: loRunning && loProgress !== -1 ? loUiText + ' ' + loProgress + '%' : loUiText

    property bool scheduled: (!item || !item.scheduled) ? false : item.scheduled

    property double size: !item ? -1 : item.size
    property double selectedSize: !item ? -1 : item.selectedSize
    property bool downloading: !item ? false : item.downloading
    property double bytesDownloaded: !item ? -1 : item.bytesDownloaded
    property double selectedBytesDownloaded: !item ? -1 : item.selectedBytesDownloaded
    property bool canUpload: item ? item.canUpload : false
    property double bytesUploaded: !item ? -1 : item.bytesUploaded
    property double ratio: bytesDownloaded ? bytesUploaded / bytesDownloaded : 0
    property string ratioText: ratio >= 0.011 ? JsTools.sizeUtils.formatByLocale(ratio.toPrecision(2)) : "0"
    property double downloadSpeed: (!item || !item.downloadSpeed) ? -1 : item.downloadSpeed
    property double estimatedTimeSec

    property bool uploading: !item ? false : item.uploading
    property double uploadSpeed: (!item || !item.uploadSpeed) ? -1 : item.uploadSpeed

    property string title: !item ? "" : item.title
    property string url: !item ? "" : (item.webPageUrl ? item.webPageUrl : item.resourceUrl)
    property string host: !url.length ? "" : App.tools.url(url).host()
    property string destinationPath: !item ? "" : item.destinationPath
    property string webPageUrl: !item ? "" : item.webPageUrl
    property string resourceUrl: !item ? "" : item.resourceUrl

    property var filesCount: item ? item.filesCount : -1
    property var singleFileInfo: item && item.filesCount == 1 ? item.fileInfo(0) : null
    property string singleFileSuffix: singleFileInfo ? singleFileInfo.suffix : ""
    property bool isFolder: item && item.filesCount > 1 ? true : false
    property bool hasChildDownloads: item ? item.hasChildDownloads : false

    property string tplTitle: !item ? "" : item.title
    property string tplPathAndTitle: hasChildDownloads ? destinationPath :
                                     destinationPath + '/' + tplTitle
    property string tplPathAndTitle2: filesCount !== 1 ? destinationPath : tplPathAndTitle

    property var added: item ? item.added : null
    property bool unknownFileSize: size === -1 || !finalDownload
    property int resumeSupport: item ? item.resumeSupport : -1

    property var tagsObj: !item ? null : App.downloads.tagsHelper.helper(itemId)
    property var allTags: []
    property var topTags: []
    property bool moreTags: false

    property var connectionsModel: !item ? null : item.connectionsModel()

    property string buttonType

    property var buttonTypes: Item {
        readonly property string start: "start"
        readonly property string pause: "pause"
        readonly property string restart: "restart"
        readonly property string showInFolder: "showInFolder"
        readonly property string scheduler: "scheduler"
    }

    property bool showProgressIndicator: false
    property bool showDownloadSpeed: downloading && (!finished || downloadSpeed > 0)
    property bool showUploadSpeed: uploading
    property bool indicatorInProgress: false
    property bool inQueue: false
    property bool inPause: false
    property bool inError: false
    property bool inCheckingFiles: false
    property bool inMergingFiles: false
    property bool inProgress: false
    property bool inWaitingForMetadata: false

    property bool inUnknownFileSize: indicatorInProgress && unknownFileSize && !inWaitingForMetadata && !inQueue && !inCheckingFiles && !inMergingFiles && !performingLo

    property int downloadProgress: -1
    property int progress: performingLo ? loProgress :
                           inCheckingFiles ? checkingFilesProgress :
                           inMergingFiles ? mergingFilesProgress :
                           downloadProgress

    property bool infinityIndicator: progress < 0 //inWaitingForMetadata || unknownFileSize

    property var error: missingStorage ? App.tools.createUnknownError(qsTr("Disk is missing") + App.loc.emptyString) :
                        missingFiles ? App.tools.createUnknownError(qsTr("File is missing") + App.loc.emptyString) :
                        downloadError

    property bool needToShowWebPageUrl: webPageUrl.length > 0
    property bool needToShowResourceUrl: resourceUrl.length > 0 &&
                                         (!needToShowWebPageUrl || webPageUrl !== resourceUrl) &&
                                         !resourceUrl.substring(0, 5).toLowerCase().startsWith("file:")

    readonly property bool canBeRestarted: item ? DownloadsTools.canBeRestarted(item) : false


    onItemIdChanged: {

        if (itemId < 0) {
            item = false;
        } else {
            item = App.downloads.infos.info(itemId);
        }
        updateState();
    }

    onFinishedChanged: updateState()
    onRunningChanged: updateState()
    onStoppingChanged: updateState()
    onAutoStartAllowedChanged: updateState()
    onDownloadErrorChanged: updateState()
    onMissingFilesChanged: updateState()
    onMissingStorageChanged: updateState()
    onFinalDownloadChanged: updateState()
    onCheckingFilesChanged: updateState()
    onMergingFilesChanged: updateState()
    onScheduledChanged: updateState()
    onLockReasonChanged: updateState()
    onPerformingLoChanged: updateState()
    onLoRunningChanged: updateState()

    onSizeChanged: {
        estimatedSecTimer.start();
        updateDownloadProgress();
    }

    onSelectedSizeChanged: {
        estimatedSecTimer.start();
        updateDownloadProgress();
    }

    onSelectedBytesDownloadedChanged: {
        estimatedSecTimer.start();
        updateDownloadProgress();
    }

    onDownloadSpeedChanged: estimatedSecTimer.start()

    function updateDownloadProgress()
    {
        if (selectedSize !== -1) {
            downloadProgress = parseInt(selectedBytesDownloaded/selectedSize*100);
        } else {
            downloadProgress = -1;
        }
    }

    Timer {
        id: estimatedSecTimer
        interval: 100;
        running: false;
        repeat: false
        onTriggered: updateEstimatedTimeSec()
    }

    function updateState()
    {
        var new_in_queue_status = false;
        var new_in_pause_status = false;
        var new_in_error_status = false;
        var new_in_checking_files_status = false;
        var new_in_merging_files_status = false;
        var new_in_progress_status = false;
        var new_waiting_for_metadata_status = false;

        buttonType = getButtonType();

        if (performingLo) {
            showProgressIndicator = true;
            indicatorInProgress = true;
        } else if (finished) {
            showProgressIndicator = false;
            indicatorInProgress = false;
            if (downloadError)
                new_in_error_status = true;
        }
        else if (downloadError) {
            showProgressIndicator = false;
            indicatorInProgress = false;
            new_in_error_status = true;
        }
        else if (running) {
            showProgressIndicator = true;
            indicatorInProgress = true;
            new_in_progress_status = true;

            if (!hasChildDownloads || downloadSpeed <= 0)
            {
                if (checkingFiles) {
                    new_in_checking_files_status = true;
                    indicatorInProgress = true;
                } else if (mergingFiles) {
                    new_in_merging_files_status = true;
                    indicatorInProgress = true;
                } else if (!finalDownload) {
                    new_waiting_for_metadata_status = true;
                }
            }
        }
        else {
            if (autoStartAllowed) {
                showProgressIndicator = true;
                indicatorInProgress = false;
                new_in_queue_status = true;
            } else {
                showProgressIndicator = true;
                indicatorInProgress = false;
                new_in_pause_status = true;
            }
        }

        if ((missingFiles || missingStorage) && lockReason == '') {
            showProgressIndicator = false;
            indicatorInProgress = false;
            new_in_error_status = true;
        }

        inQueue = new_in_queue_status;
        inPause = new_in_pause_status;
        inError = new_in_error_status;
        inCheckingFiles = new_in_checking_files_status;
        inMergingFiles = new_in_merging_files_status;
        inProgress = new_in_progress_status;
        inWaitingForMetadata = new_waiting_for_metadata_status;

        updateTopTags();
    }

    function updateTopTags() {
        if (tagsObj) {
            var allTagsTmp = [];
            var tag;
            for (var i = 0; i < tagsObj.tags.length; i++) {
                tag = tagsTools.getTag(tagsObj.tags[i]);
                if (!tag.readOnly) {
                    allTagsTmp.push(tagsTools.getTag(tagsObj.tags[i]));
                }
            }
            allTags = allTagsTmp;
            topTags = allTags.slice(0, 3);
            moreTags = tagsObj ? tagsObj.tags.filter(e => e > 0).length > topTags.length : false;
        }
    }

    function getButtonType()
    {
        var buttonType = buttonTypes.showInFolder;

        if (finished) {
            buttonType = buttonTypes.showInFolder;
        }
//        else if (error) {
//            buttonType = buttonTypes.restart
//        }
        else if (running) {
            buttonType = buttonTypes.pause
        }
        else {
            if (autoStartAllowed) {
                buttonType = buttonTypes.pause
            } else {
                if (scheduled) {
                    buttonType = buttonTypes.scheduler
                } else {
                    buttonType = buttonTypes.start
                }
            }
        }

        return buttonType;
    }

    function doAction()
    {
        switch (buttonType) {
        case buttonTypes.showInFolder:
            if (!App.rc.client.active)
                App.downloads.mgr.openDownloadFolder(itemId, -1);
            break;
        case buttonTypes.restart:
            if (!finished && (downloadError || missingFiles) && (flags & AbstractDownloadsUi.SupportsRestart) != 0) {
                App.downloads.mgr.restartDownload(itemId);
                appWindow.startDownload();
            }
            break;
        case buttonTypes.start:
            App.downloads.mgr.startDownload(itemId, true);
            appWindow.startDownload();
            break;
        case buttonTypes.pause:
            stopDownload();
            break;
        case buttonTypes.scheduler:
            appWindow.openScheduler(itemId);
            break;
        }
    }

    function stopDownload()
    {
        if (scheduled) {
            App.downloads.scheduler.removeSchedule(itemId);
        }
        if (resumeSupport == AbstractDownloadsUi.DownloadResumeSupportAbsent) {
            appWindow.stopDownload([itemId]);
        } else {
            App.downloads.mgr.stopDownload(itemId, false);
        }
    }

    function changeChecked()
    {
        if (item) {
            App.downloads.model.setChecked(itemId, !App.downloads.model.isChecked(itemId));
        }
    }

    property double lastRemainingTimeValue
    property double calcRemainingTimestamp

    function updateEstimatedTimeSec()
    {
        var remaining_bytes = selectedSize - selectedBytesDownloaded;
        var download_speed_bytes = App.downloads.speedTracker.averageDownloadSpeed(itemId);

        var current_timestamp = parseInt( + new Date() / 1000 );

        var real_remaining_time = calcRemainingSec(remaining_bytes, download_speed_bytes);
        var last_remaining_time = lastRemainingTimeValue - (current_timestamp - calcRemainingTimestamp);

        var abs = Math.abs(real_remaining_time - last_remaining_time);
        var error_percent = Math.max(abs/real_remaining_time * 100, abs/last_remaining_time * 100);
        var time_diff = current_timestamp - calcRemainingTimestamp;

        if (time_diff > 20
            || last_remaining_time <= 0
            || error_percent > 100
            || error_percent > 30 && time_diff > 5
            || error_percent > 10 && time_diff > 10
            || real_remaining_time < 10000
        ){
            calcRemainingTimestamp = current_timestamp;
            lastRemainingTimeValue = real_remaining_time;

            estimatedTimeSec = real_remaining_time;
        }
        else{
            estimatedTimeSec = lastRemainingTimeValue - time_diff * 1000;
        }
    }

    function calcRemainingSec(rb, dsb){

        var remaining_bytes = rb;
        var download_speed_bytes = dsb;

        var remaining_sec = -1;
        if(remaining_bytes > 0 && download_speed_bytes > 0) {
            remaining_sec = (remaining_bytes / download_speed_bytes) * 1000;
        }

        return remaining_sec;
    }

    Connections {
        target: tagsObj
        onTagsChanged: updateTopTags()
    }

    function abortLo()
    {
        if (lockReason == "convertFilesToMp3" ||
                lockReason == "convertFilesToMp4")
        {
            App.downloads.mgr.abortConvertFiles([itemId]);
        }
    }
}
