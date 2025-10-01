import QtQuick 2.0
import Qt.labs.platform 1.0 as QtLabs
import org.freedownloadmanager.fdm 1.0
import "../../common/Tools"

QtLabs.FolderDialog {
    property var ids: []
    acceptLabel: qsTr("Move") + App.loc.emptyString
    rejectLabel: qsTr("Cancel") + App.loc.emptyString
    folder: uiSettingsTools.settings.lastMovePath
    onAccepted: {
        if (ids.length) {
            uiSettingsTools.settings.lastMovePath = folder;
            DownloadsTools.moveDownloads(ids, App.tools.url(folder).toLocalFile());
        }
        ids = [];
    }
    onRejected:  {
        ids = [];
    }
    function openForIds(ids0) {
        ids = ids0;
        open();
    }
}
