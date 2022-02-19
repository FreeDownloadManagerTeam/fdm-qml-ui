import QtQuick 2.0
import Qt.labs.platform 1.0 as QtLabs
import org.freedownloadmanager.fdm 1.0

QtLabs.FileDialog {
    id: exportSettingsDlg
    property bool opened: visible
    fileMode: QtLabs.FileDialog.SaveFile
    acceptLabel: qsTr("Export") + App.loc.emptyString
    rejectLabel: qsTr("Cancel") + App.loc.emptyString
    nameFilters: [ qsTr("%1 settings files (%2)").arg(App.shortDisplayName).arg("*.fds") + App.loc.emptyString, qsTr("All files (%1)").arg("*") + App.loc.emptyString ]
    currentFile: App.tools.urlFromLocalFile(uiSettingsTools.settings.exportImportPath).url + "/" + App.shortDisplayName.toLowerCase() + '_settings' + '.fds';
    onAccepted: {
        App.exportImport.exportSettings(App.tools.url(file).toLocalFile())
        uiSettingsTools.settings.exportImportPath = App.tools.url(folder).toLocalFile();
    }
}
