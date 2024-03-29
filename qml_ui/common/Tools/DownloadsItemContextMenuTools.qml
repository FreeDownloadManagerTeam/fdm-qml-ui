import QtQuick 2.0
import org.freedownloadmanager.fdm 1.0
import org.freedownloadmanager.fdm.appfeatures 1.0
import org.freedownloadmanager.fdm.abstractdownloadsui 1.0


Item {
    id: root
    property double modelId
    property bool finished
    property bool singleDownload

    property bool canBeOpened: false
    property bool canBeShownInFolder: App.features.hasFeature(AppFeatures.OpenFolder)

    onFinishedChanged: updateState()
    Component.onCompleted: updateState()

    function updateState()
    {
        let cbo = false;

        if (singleDownload)
        {
            if (root.finished)
            {
                cbo = true;
            }
            else
            {
                let info = App.downloads.infos.info(modelId);
                if (info.nonSkippedFilesCount() === 1)
                {
                    let index = info.firstNonSkippedFileIndex();
                    if (index >= 0)
                    {
                        let f = info.fileInfo(index);
                        if (f && (f.flags & AbstractDownloadsUi.FileMediaReadyToPlay))
                            cbo = true;
                    }
                }
            }
        }

        canBeOpened = cbo;
    }

    function openClick()
    {
        if (!App.rc.client.active)
            App.downloads.mgr.openDownload(modelId, -1)
    }

    function showInFolderClick()
    {
        if (!App.rc.client.active)
            App.downloads.mgr.openDownloadFolder(modelId, -1)
    }

    function copyLinkClick()
    {
        App.clipboard.text = App.downloads.infos.info(modelId).resourceUrl
    }

    function openDownloadPageClick()
    {
        App.openDownloadUrl(App.downloads.infos.info(modelId).webPageUrl);
    }

    function openDownloadPageAllowed()
    {
        return App.downloads.infos.info(modelId).webPageUrl.toString().length > 0;
    }

    function setDownloadsPriority(priority)
    {
        App.downloads.infos.info(modelId).priority = priority;
    }

    function getDownloadsPriorityChecked(priority)
    {
        return (App.downloads.infos.info(modelId).priority == priority);
    }

    function restartClick()
    {
        App.downloads.mgr.restartDownload(modelId);
    }

    function hasError() {
        return App.downloads.infos.info(modelId).error.hasError;
    }

    function reportProblem() {
        privacyDlg.open(modelId)
    }
}
