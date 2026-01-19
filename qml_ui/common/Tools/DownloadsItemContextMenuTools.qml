import QtQuick
import org.freedownloadmanager.fdm
import org.freedownloadmanager.fdm.appfeatures
import org.freedownloadmanager.fdm.abstractdownloadsui 


Item {
    id: root
    property double modelId
    property bool finished
    property bool singleDownload

    property bool canBeOpened: false
    property bool canBeShownInFolder: App.features.hasFeature(AppFeatures.OpenFolder)
    property bool canShareFile: false

    onFinishedChanged: updateState()
    Component.onCompleted: updateState()

    function updateState()
    {
        let cbo = false;
        let csf = false;

        if (singleDownload)
        {
            let info = App.downloads.infos.info(modelId);

            if (root.finished)
            {
                cbo = true;
                csf = info.filesCount === 1;
            }
            else
            {
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

        if (csf && !App.features.hasFeature(AppFeatures.ShareFile))
            csf = false;

        canBeOpened = cbo;
        canShareFile = csf;
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

    function shareFileClick()
    {
        if (!App.rc.client.active)
        {
            let info = App.downloads.infos.info(modelId);
            let file = info.fileInfo(0);
            App.tools.shareFile(info.destinationPath + "/" + file.path);
        }
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
