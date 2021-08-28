import QtQuick 2.12
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtQuick.Dialogs 1.3
import QtGraphicalEffects 1.0
import org.freedownloadmanager.fdm 1.0
import org.freedownloadmanager.fdm.dmcoresettings 1.0
import org.freedownloadmanager.fdm.appsettings 1.0
import org.freedownloadmanager.fdm.appfeatures 1.0
import "../../desktop/BaseElements"
import "../../desktop/SettingsPage"
import Qt.labs.platform 1.0 as QtLabs

Column
{
    id: root

    spacing: 0
    width: parent.width

    SettingsGroupHeader
    {
        text: appWindow.btS.protocolName
    }

    SettingsGroupColumn
    {
        SettingsSubgroupHeader
        {
            text: qsTr("General") + App.loc.emptyString
        }

        IntegrationSettings {}

        SettingsCheckBox
        {
            text: App.my_BT_qsTranslate("Settings", "Automatically delete .torrent files once the download is finished") + App.loc.emptyString
            checked: App.settings.toBool(
                         App.settings.dmcore.value(
                             DmCoreSettings.DeleteLocalServiceFilesWhenDownloadFinished))
            onClicked: {
                App.settings.dmcore.setValue(
                            DmCoreSettings.DeleteLocalServiceFilesWhenDownloadFinished,
                            App.settings.fromBool(checked));
            }
        }
    }

    SettingsGroupColumn
    {
        id: monitoring

        SettingsSubgroupHeader
        {
            text: qsTr("Monitoring") + App.loc.emptyString
        }

        SettingsCheckBox
        {
            id: torrentFolderCheck
            text: App.my_BT_qsTranslate("Settings", "Monitor folder for new .torrent files") + App.loc.emptyString
            checked: App.settings.app.value(AppSettings.TorrentsFolder)
            onClicked: monitoring.applySettings()
        }

        RowLayout
        {
            id: torrentFolderSettings

            enabled: torrentFolderCheck.checked

            x: torrentFolderCheck.x + 20
            width: root.width - x

            SettingsTextField
            {
                id: torrentFolder
                readOnly: true
                Layout.fillWidth: true
                text: App.localDecodePath(App.settings.app.value(AppSettings.TorrentsFolder).length ?
                                              App.settings.app.value(AppSettings.TorrentsFolder) :
                                              App.systemDefaultDownloadPath())
                onTextChanged: monitoring.applySettings()
            }

            CustomButton {
                id: folderBtn
                implicitWidth: 38
                implicitHeight: 25
                Layout.alignment: Qt.AlignRight
                clip: true
                Image {
                    source: Qt.resolvedUrl("../../images/desktop/pick_file.svg")
                    sourceSize.width: 37
                    sourceSize.height: 30
                    y: -5
                    layer {
                        effect: ColorOverlay {
                            color: folderBtn.isPressed ? folderBtn.secondaryTextColor : folderBtn.primaryTextColor
                        }
                        enabled: true
                    }
                }
                onClicked: browseDlg.open()
                QtLabs.FolderDialog {
                    id: browseDlg
                    folder: App.tools.urlFromLocalFile(torrentFolder.text).url
                    acceptLabel: qsTr("Open") + App.loc.emptyString
                    rejectLabel: qsTr("Cancel") + App.loc.emptyString
                    onAccepted: torrentFolder.text = App.tools.url(folder).toLocalFile()
                }
            }
        }

        SettingsCheckBox
        {
            id: torrentFolderSilent
            enabled: torrentFolderCheck.checked
            anchors.leftMargin: 25
            text: qsTr("Start downloading without confirmation") + App.loc.emptyString
            checked: App.settings.toBool(
                         App.settings.app.value(AppSettings.ForceSilentDownloadsFromTorrentFolder))
            onClicked: monitoring.applySettings()
        }

        function applySettings()
        {
            var path = torrentFolderCheck.checked ?
                        torrentFolder.text :
                        "";
            App.settings.app.setValue(
                        AppSettings.TorrentsFolder,
                        App.localEncodePath(path));
            App.settings.app.setValue(
                        AppSettings.ForceSilentDownloadsFromTorrentFolder,
                        App.settings.fromBool(torrentFolderSilent.checked));
        }
    }
}
