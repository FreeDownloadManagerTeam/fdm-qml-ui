import QtQuick 2.0
import org.freedownloadmanager.fdm 1.0

Item {

    id: root

    property double newDownloadId: -1
    property double existingDownloadId: -1

    property variant chooserObj: null
    property variant allOptions
    property variant choosenOptions

    property bool dialogEnabled: false
    property bool mergeBtnEnabled: false

    signal wasResetted

    function newMergeRequest(newDownloadId, existingDownloadId)
    {
        if (chooserObj !== null) {
            return false;
        }
        chooserObj = App.downloads.mergeOptionsChooser;
        root.newDownloadId = newDownloadId;
        root.existingDownloadId = existingDownloadId ? existingDownloadId : chooserObj.existingDownloadId(newDownloadId);
        allOptions = chooserObj.allOptions(newDownloadId);
        mergeBtnEnabled = allOptions.dontMergeJustAddNew;
        dialogEnabled = true;
        return true;
    }

    function closeBuildDownloadDialog()
    {
        if (!appWindow.mobileVersion && typeof buildDownloadDlg !== 'undefined' && buildDownloadDlg.opened) {
            buildDownloadDlg.close();
        }

        if (!appWindow.mobileVersion && typeof tuneAddDownloadDlg !== 'undefined' && tuneAddDownloadDlg.opened) {
            tuneAddDownloadDlg.close();
        }
    }

    function closeBuildDownloadMobile()
    {
        if (appWindow.mobileVersion) {
            if (stackView.depth > 0) {
                var current_page = stackView.currentItem;
                var current_page_name = current_page.pageName;
                if (['BuildDownloadPage', 'TuneAndAddDownloadPage'].indexOf(current_page_name) >= 0) {
                    stackView.pop();
                }
            }
        }
    }

    function dontMerge()
    {
        choosenOptions = chooserObj.choosenOptions(newDownloadId);
        choosenOptions.dontMergeJustAddNew = true;
        mergeTools.dialogEnabled = false;
        chooserObj.commit(newDownloadId, false);
        mergeDownloadsDlg.close();
        reset();
    }

    function reject()
    {
        mergeTools.dialogEnabled = false;
        chooserObj.commit(newDownloadId, true);
        closeBuildDownloadMobile();
        mergeDownloadsDlg.close();
        reset();
    }

    function accept()
    {
        mergeTools.dialogEnabled = false;
        skipDownload(newDownloadId);
        mergeDownloadsDlg.close();
        closeBuildDownloadMobile();
        selectedDownloadsTools.selectDownloadItemById(existingDownloadId);
        reset();
    }

    function acceptAll()
    {
        mergeTools.dialogEnabled = false;

        var id;
        while (id = interceptionTools.getMergeRequestId()) {
            skipDownload(id);
        }

        mergeDownloadsDlg.close();
        closeBuildDownloadMobile();
        selectedDownloadsTools.selectDownloadItemById(existingDownloadId);
        reset();
    }

    function skipDownload(newDownloadId)
    {
        allOptions = chooserObj.allOptions(newDownloadId);
        for (var i = 0; i < allOptions.textOptions.length; i++) {
            choosenOptions = chooserObj.choosenOptions(newDownloadId);
            choosenOptions.enableTextOption(allOptions.textOptions[i], true);
        }
        chooserObj.commit(newDownloadId, false);
    }

    function reset()
    {
        dialogEnabled = false;
        newDownloadId = -1;
        existingDownloadId = -1;
        chooserObj = null;
        allOptions = null;
        choosenOptions = null;
        wasResetted();
    }
}
