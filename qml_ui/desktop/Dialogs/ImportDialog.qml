import QtQuick
import QtQuick.Dialogs
import org.freedownloadmanager.fdm

FileDialog {
    property bool opened: visible
    property string action

    acceptLabel: qsTr("Import") + App.loc.emptyString
    rejectLabel: qsTr("Cancel") + App.loc.emptyString

    currentFolder: App.tools.urlFromLocalFile(uiSettingsTools.settings.exportImportPath).url

    property string filter

    nameFilters: [ filter, qsTr("All files (%1)").arg("*") + App.loc.emptyString]

    onAccepted: {
        if (action === 'importListOfUrlsFromFile') {
            App.importListOfUrlsFromFile(App.tools.url(selectedFile).toLocalFile());
        } else if (action === 'importDownloads') {
            App.exportImport.importDownloads(App.tools.url(selectedFile).toLocalFile());
        } else if (action === 'importSettings') {
            App.exportImport.importSettings(App.tools.url(selectedFile).toLocalFile());
        }
        uiSettingsTools.settings.exportImportPath = App.tools.url(currentFolder).toLocalFile();
    }

    function openDialog(actionValue) {
        if (!opened) {
            action = actionValue;
            if (action === 'importListOfUrlsFromFile') {
                filter = qsTr("Text files (%1)").arg("*.txt") + App.loc.emptyString;
            } else if (action === 'importDownloads') {
                filter = qsTr("%1 downloads files (%2)").arg(App.shortDisplayName).arg("*.fdd") + App.loc.emptyString;
            } else if (action === 'importSettings') {
                filter = qsTr("%1 settings files (%2)").arg(App.shortDisplayName).arg("*.fds") + App.loc.emptyString;
            }
            open();
        }
    }
}
