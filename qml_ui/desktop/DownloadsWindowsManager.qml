import QtQml 2.12
import QtQuick 2.12
import org.freedownloadmanager.fdm 1.0
import "../common"

Item
{
    // optional todo: let the user choose?
    readonly property bool parentLessDownloadsOnly: true

    property bool isInitialized: false

    property var managerEnabled: uiSettingsTools.settings.enableStandaloneDownloadsWindows
    property var downloadsWindows: []

    ComponentLoader
    {
        id: downloadWindowC
        source: Qt.resolvedUrl("DownloadWindow.qml")
        onLoaded: initializeIfRequired()
    }

    Component.onCompleted: initializeIfRequired()
    Component.onDestruction: closeAllWindows()

    function initializeIfRequired()
    {
        if (isInitialized)
            return;
        if (!downloadWindowC.isLoaded())
            return;
        isInitialized = true;
        if (managerEnabled)
            openAllWindows();
    }

    function openAllWindows()
    {
        var ids = App.downloads.tracker.runningIds();
        ids.forEach(id => checkAndCreateWindow(id));
    }

    function closeAllWindows()
    {
        var ws = downloadsWindows;
        downloadsWindows = [];
        ws.forEach(w => w.destroy());
    }

    Connections
    {
        target: App.downloads.tracker
        onDownloadRunning: {
            if (!managerEnabled)
                return;
            if (isRunning)
                checkAndCreateWindow(id);
            else
                checkAndDestroyWindow(id);
        }
        onDownloadFinished: {
            if (!managerEnabled)
                return;
            checkAndDestroyWindow(id);
        }
        onDownloadBecameNonFinishedBeingFinishedBefore: {
            if (!managerEnabled)
                return;
            if (App.downloads.tracker.isRunningDownload(id))
                checkAndCreateWindow(id);
        }
    }

    function findWindowIndex(downloadId)
    {
        for (var i = 0; i < downloadsWindows.length; ++i)
        {
            if (downloadsWindows[i].downloadId === downloadId)
                return i;
        }
        return -1;
    }

    function createWindow(downloadId)
    {
        var index = findWindowIndex(downloadId);
        if (index !== -1)
        {
            if (!downloadsWindows[index].visible)
                downloadsWindows[index].visible = true;
            return;
        }
        var window = downloadWindowC.createObject(
                    null,
                    {downloadId: downloadId});
        downloadsWindows.push(window);
    }

    function isIgnoredDownload(downloadId)
    {
        var info = App.downloads.infos.info(downloadId);
        if (!info)
            return true;

        if (parentLessDownloadsOnly)
        {
            if (info.parentId !== -1)
                return true;
        }
        else
        {
            if (info.hasChildDownloads)
                return true;
        }

        return false;
    }

    function checkAndCreateWindow(downloadId)
    {
        if (isIgnoredDownload(downloadId) ||
                !App.downloads.tracker.isNonFinishedDownload(downloadId))
        {
            return;
        }

        createWindow(downloadId);
    }

    function checkAndDestroyWindow(downloadId)
    {
        var index = findWindowIndex(downloadId);
        if (index === -1)
            return;
        if (downloadsWindows[index].isCloseWhenStoppedChecked() ||
                !downloadsWindows[index].visible)
        {
            destroyWindow(downloadId);
        }
    }

    function destroyWindow(downloadId)
    {
        var index = findWindowIndex(downloadId);
        if (index !== -1)
        {
            var window = downloadsWindows[index];
            downloadsWindows.splice(index, 1);
            window.destroy();
        }
    }

    onManagerEnabledChanged: {
        if (managerEnabled)
            openAllWindows();
        else
            closeAllWindows();
    }
}
