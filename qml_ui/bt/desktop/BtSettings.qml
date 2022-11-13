import QtQuick 2.12
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import "../../qt5compat"
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

            x: torrentFolderCheck.x + 20*appWindow.zoom
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

            PickFileButton {
                id: folderBtn
                Layout.alignment: Qt.AlignRight
                Layout.preferredHeight: 25*appWindow.zoom
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
            anchors.leftMargin: 25*appWindow.zoom
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

    SettingsGroupColumn
    {
        SettingsSubgroupHeader
        {
            text: qsTr("Advanced") + App.loc.emptyString
        }

        SettingsCheckBox
        {
            id: useSystemDefinedPort
            text: App.my_BT_qsTranslate("Settings", "Use system defined port for incoming connections") + App.loc.emptyString
            checked: (parseInt(App.settings.dmcore.value(DmCoreSettings.BtSessionPort)) || 0) <= 0
            onClicked: {
                applyAdvancedBtSettings();
                if (!checked)
                {
                    customPortText.forceActiveFocus();
                    customPortText.selectAll();
                }
            }
        }

        Row {
            visible: !useSystemDefinedPort.checked
            leftPadding: 40*appWindow.zoom
            spacing: 5*appWindow.zoom

            SettingsSubgroupHeader {
                text: qsTr("Custom port:") + App.loc.emptyString
                anchors.verticalCenter: parent.verticalCenter
            }

            SettingsTextField {
                id: customPortText
                implicitWidth: 60*appWindow.zoom
                inputMethodHints: Qt.ImhDigitsOnly
                validator: QtRegExpValidator { regExp: /\d+/ }
                text: App.settings.dmcore.value(DmCoreSettings.BtSessionPort)
                onTextChanged: applyAdvancedBtSettings()
            }
        }

        SettingsCheckBox
        {
            id: enableTrackerList
            text: App.my_BT_qsTranslate("Settings", "Enable list of predefined trackers") + App.loc.emptyString
            checked: parseInt(App.settings.dmcore.value(DmCoreSettings.BtEnableTrackerList))
            onClicked: {
                App.settings.dmcore.setValue(
                            DmCoreSettings.BtEnableTrackerList,
                            App.settings.fromBool(checked));
                if (checked)
                    trackerList.forceActiveFocus();
            }
        }

        Column
        {
            visible: enableTrackerList.checked

            x: enableTrackerList.x + 20*appWindow.zoom
            width: root.width - x

            spacing: 10*appWindow.zoom

            BaseHyperLabel
            {
                font.pixelSize: 12*appWindow.fontZoom
                text: qsTr("The use of additional trackers can improve download speed in some cases. Lists of such trackers can be retrieved from different sources, e.g. from <a href='https://github.com/ngosang/trackerslist'>here</a>.") + App.loc.emptyString
                width: parent.width
                wrapMode: Text.WordWrap
            }

            BaseStringListArea
            {
                id: trackerList
                width: parent.width
                height: 100*appWindow.fontZoom
                isValidItem: function(str) {
                    return str.startsWith("http://") ||
                            str.startsWith("https://") ||
                            str.startsWith("udp://") ||
                            str.startsWith("ws://") ||
                            str.startsWith("wss://");
                }
                Component.onCompleted: {
                    setString(App.settings.dmcore.value(DmCoreSettings.BtTrackerList));
                }
                Component.onDestruction: {
                    App.settings.dmcore.setValue(
                                DmCoreSettings.BtTrackerList,
                                getString());
                }
            }
        }
    }

    function applyAdvancedBtSettings()
    {
        var port = 0;

        if (!useSystemDefinedPort.checked && customPortText.text)
            port = parseInt(customPortText.text) || 0;

        if (port >= 0 && port <= 65535)
        {
            App.settings.dmcore.setValue(
                        DmCoreSettings.BtSessionPort,
                        port);
        }
    }
}
