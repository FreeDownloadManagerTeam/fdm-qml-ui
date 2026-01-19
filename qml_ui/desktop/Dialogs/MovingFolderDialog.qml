import QtQuick
import QtQuick.Dialogs
import org.freedownloadmanager.fdm
import "../../common/Tools"

FolderDialog {
    property var ids: []
    acceptLabel: qsTr("Move") + App.loc.emptyString
    rejectLabel: qsTr("Cancel") + App.loc.emptyString
    currentFolder: uiSettingsTools.settings.lastMovePath
    onAccepted: {
        if (ids.length) {
            uiSettingsTools.settings.lastMovePath = currentFolder;
            DownloadsTools.moveDownloads(ids, App.tools.url(currentFolder).toLocalFile());
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
