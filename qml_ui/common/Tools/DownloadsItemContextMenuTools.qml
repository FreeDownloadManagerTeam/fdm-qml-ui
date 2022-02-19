import QtQuick 2.0
import org.freedownloadmanager.fdm 1.0
import org.freedownloadmanager.fdm.appfeatures 1.0

Item {
    id: root
    property double modelId
    property bool finished

    property bool canBeOpened: false
    property bool canBeShownInFolder: App.features.hasFeature(AppFeatures.OpenFolder)

    onFinishedChanged: updateState()
    Component.onCompleted: updateState()

    function updateState()
    {
        canBeOpened = root.finished
    }

    function openClick()
    {
        App.downloads.mgr.openDownload(modelId, -1)
    }

    function showInFolderClick()
    {
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
