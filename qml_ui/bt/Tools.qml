import QtQuick 2.0
import org.freedownloadmanager.fdm 1.0

Item {
    id: root

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
}
