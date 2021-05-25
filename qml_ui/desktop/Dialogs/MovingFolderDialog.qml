import QtQuick 2.0
import Qt.labs.platform 1.0 as QtLabs
import org.freedownloadmanager.fdm 1.0

QtLabs.FolderDialog {
    id: movingFolderDlg
    acceptLabel: qsTr("Move") + App.loc.emptyString
    rejectLabel: qsTr("Cancel") + App.loc.emptyString
    folder: uiSettingsTools.settings.lastMovePath
    onAccepted: {
        uiSettingsTools.settings.lastMovePath = folder;
        selectedDownloadsTools.moveCurrentDownloads(App.tools.url(folder).toLocalFile());
    }
}
