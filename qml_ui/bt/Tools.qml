import QtQuick
import org.freedownloadmanager.fdm

Item {
    id: root

    readonly property string btSessionListeningPortInfo: "btSessionListeningPort"

    property var btModule: null
    property int sessionPort: 0

    function addTAllowed()
    {
        var allowed = true;
        var download = null;
        var ids = selectedDownloadsTools.getCurrentDownloadIds();
        if (ids.length > 0) {
            for (var i = 0; i < ids.length; i++) {
                download = App.downloads.infos.info(ids[i]);
                if (download.moduleUid != "downloadsbt") {
                    allowed = false;
                    break;
                }
            }
        }
        return allowed;
    }

    function disablePostFinishedTasksAllowed()
    {
        var allowed = false;
        var ids = selectedDownloadsTools.getCurrentDownloadIds();
        if (ids.length > 0) {
            for (var i = 0; i < ids.length; i++) {
                if (App.downloads.infos.info(ids[i]).hasPostFinishedTasks) {
                    allowed = true;
                    break;
                }
            }
        }
        return allowed;
    }

    function disablePostFinishedTasksChecked()
    {
        var checked = true;
        var ids = selectedDownloadsTools.getCurrentDownloadIds();
        if (ids.length > 0) {
            for (var i = 0; i < ids.length; i++) {
                if (!(App.downloads.infos.info(ids[i]).disablePostFinishedTasks || !App.downloads.infos.info(ids[i]).autoStartAllowed)) {
                    checked = false;
                    break;
                }
            }
        }
        return checked;
    }

    function disablePostFinishedTasks(value)
    {
        var ids = selectedDownloadsTools.getCurrentDownloadIds();
        if (ids.length > 0) {
            for (var i = 0; i < ids.length; i++) {
                App.downloads.infos.info(ids[i]).disablePostFinishedTasks = value;
                if (!value) {
                    App.downloads.infos.info(ids[i]).autoStartAllowed = true;
                }
            }
        }
    }

    function ignoreURatioLimitAllowed()
    {
        var allowed = false;
        var ids = selectedDownloadsTools.getCurrentDownloadIds();
        if (ids.length > 0) {
            for (var i = 0; i < ids.length; i++) {
                if (App.downloads.infos.info(ids[i]).hasPostFinishedTasks) {
                    allowed = true;
                    break;
                }
            }
        }
        return allowed;
    }

    function ignoreURatioLimitChecked()
    {
        var checked = true;
        var ids = selectedDownloadsTools.getCurrentDownloadIds();
        if (ids.length > 0) {
            for (var i = 0; i < ids.length; i++) {
                if (!App.downloads.infos.info(ids[i]).ignoreURatioLimit) {
                    checked = false;
                    break;
                }
            }
        }
        return checked;
    }

    function ignoreURatioLimit(value)
    {
        var ids = selectedDownloadsTools.getCurrentDownloadIds();
        if (ids.length > 0) {
            for (var i = 0; i < ids.length; i++) {
                if (App.downloads.infos.info(ids[i]).hasPostFinishedTasks)
                    App.downloads.infos.info(ids[i]).ignoreURatioLimit = value;
            }
        }
    }

    function forceReannounceAllowed()
    {
        let ids = selectedDownloadsTools.getCurrentDownloadIds();
        for (let i = 0; i < ids.length; i++)
        {
            let info = App.downloads.infos.info(ids[i]);
            if (info.moduleUid !== "downloadsbt" ||
                    !info.running)
            {
                return false;
            }
        }
        return true;
    }

    function forceReannounce()
    {
        App.downloads.mgr.doCustomCommand(
                    selectedDownloadsTools.getCurrentDownloadIds(),
                    "forceReannounce",
                    undefined);
    }

    Connections
    {
        target: App
        onReadyChanged: {
            if (App.ready)
                refreshModule();
        }
    }

    Component.onCompleted: {
        if (App.ready)
            refreshModule();
    }

    Connections
    {
        target: App.downloadsModules
        onModulesUidsChanged: refreshModule()
    }

    function refreshModule()
    {
        let m = App.downloadsModules.module("downloadsbt");
        if (btModule === m)
            return;
        btModule = m;
        if (!btModule)
        {
            sessionPort = 0;
            return;
        }
        btModule.customInfoChanged.connect(function(id) {
            if (id === btSessionListeningPortInfo)
                refreshSessionPort();
        });
        refreshSessionPort();
    }

    function refreshSessionPort()
    {
        if (btModule.hasCustomInfoValue(btSessionListeningPortInfo))
            sessionPort = btModule.getCustomInfo(btSessionListeningPortInfo) || 0;
        else
            btModule.getCustomInfo(btSessionListeningPortInfo);
    }
}
