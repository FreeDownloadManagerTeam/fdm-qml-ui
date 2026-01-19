import QtQuick
import QtQuick.Dialogs
import org.freedownloadmanager.fdm

FileDialog {
    id: exportSettingsDlg
    property bool opened: visible
    fileMode: FileDialog.SaveFile
    acceptLabel: qsTr("Export") + App.loc.emptyString
    rejectLabel: qsTr("Cancel") + App.loc.emptyString
    nameFilters: [ qsTr("%1 settings files (%2)").arg(App.shortDisplayName).arg("*.fds") + App.loc.emptyString, qsTr("All files (%1)").arg("*") + App.loc.emptyString ]
    currentFolder: App.tools.urlFromLocalFile(uiSettingsTools.settings.exportImportPath).url
    selectedFile: App.tools.urlFromLocalFile(uiSettingsTools.settings.exportImportPath + "/" + App.shortDisplayName.toLowerCase() + "_settings.fds").url
    onAccepted: {
        App.exportImport.exportSettings(App.tools.url(selectedFile).toLocalFile())
        uiSettingsTools.settings.exportImportPath = App.tools.url(currentFolder).toLocalFile();
    }
}
