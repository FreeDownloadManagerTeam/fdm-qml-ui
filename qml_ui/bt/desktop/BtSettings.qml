import QtQuick 2.12
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import "../../qt5compat"
import org.freedownloadmanager.fdm 1.0
import org.freedownloadmanager.fdm.abstractdownloadsui 1.0
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
        anchors.left: parent.left

        SettingsSubgroupHeader
        {
            anchors.left: parent.left
            text: qsTr("General") + App.loc.emptyString
        }

        IntegrationSettings
        {
            anchors.left: parent.left
        }

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

        anchors.left: parent.left

        width: parent.width

        SettingsSubgroupHeader
        {
            anchors.left: parent.left
            text: qsTr("Monitoring") + App.loc.emptyString
        }

        SettingsCheckBox
        {
            id: torrentFolderCheck
            text: App.my_BT_qsTranslate("Settings", "Monitor folder for new .torrent files") + App.loc.emptyString
            checked: App.settings.app.value(AppSettings.TorrentsFolder)
            onClicked: monitoring.applySettings()
        }

        Column
        {
            anchors.left: parent.left
            anchors.leftMargin: 32*appWindow.zoom
            spacing: 8*appWindow.zoom
            width: parent.width

            RowLayout
            {
                enabled: torrentFolderCheck.checked

                anchors.left: parent.left

                width: Math.min(parent.width, 500*appWindow.zoom)

                SettingsTextField
                {
                    id: torrentFolder
                    readOnly: true
                    Layout.fillWidth: true
                    text: App.toNativeSeparators(
                              App.localDecodePath(App.settings.app.value(AppSettings.TorrentsFolder).length ?
                                                      App.settings.app.value(AppSettings.TorrentsFolder) :
                                                      App.systemDefaultDownloadPath()))
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
                anchors.leftMargin: 0
                xOffset: 0
                text: qsTr("Start downloading without confirmation") + App.loc.emptyString
                checked: App.settings.toBool(
                             App.settings.app.value(AppSettings.ForceSilentDownloadsFromTorrentFolder))
                onClicked: monitoring.applySettings()
            }
        }

        function applySettings()
        {
            var path = torrentFolderCheck.checked ?
                        App.fromNativeSeparators(torrentFolder.text) :
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
        anchors.left: parent.left

        SettingsSubgroupHeader
        {
            anchors.left: parent.left
            text: qsTr("Privacy") + App.loc.emptyString
        }

        Row {
            anchors.left: parent.left
            leftPadding: qtbug.leftPadding(17*appWindow.zoom, 0)
            rightPadding: qtbug.rightPadding(17*appWindow.zoom, 0)
            spacing: 10*appWindow.zoom

            SettingsSubgroupHeader {
                text: qsTr("Encryption:") + App.loc.emptyString
                anchors.verticalCenter: parent.verticalCenter
            }

            BaseComboBox {
                settingsStyle: true
                anchors.verticalCenter: parent.verticalCenter
                model: [
                    {text: qsTr("No encryption allowed") + App.loc.emptyString, value: AbstractDownloadsUi.NoEncryptionAllowed},
                    {text: qsTr("Prefer encryption") + App.loc.emptyString, value: AbstractDownloadsUi.PreferEncryption},
                    {text: qsTr("Require encryption") + App.loc.emptyString, value: AbstractDownloadsUi.RequireEncryption},
                ]
                currentIndex: {
                    let v = parseInt(App.settings.dmcore.value(DmCoreSettings.BtEncryptionPolicy));
                    for (let i = 0; i < model.length; ++i) {
                        if (model[i].value === v)
                            return i;
                    }
                    return 0;
                }
                onActivated: (index) => App.settings.dmcore.setValue(DmCoreSettings.BtEncryptionPolicy, model[index].value.toString())
            }
        }

        SettingsCheckBox
        {
            text: App.my_BT_qsTranslate("Settings", "Enable DHT to find more peers") + App.loc.emptyString
            checked: App.settings.toBool(App.settings.dmcore.value(DmCoreSettings.BtEnableDht))
            onClicked: App.settings.dmcore.setValue(DmCoreSettings.BtEnableDht,
                                                    App.settings.fromBool(checked))
        }

        SettingsCheckBox
        {
            text: App.my_BT_qsTranslate("Settings", "Enable PeX to find more peers") + App.loc.emptyString
            checked: App.settings.toBool(App.settings.dmcore.value(DmCoreSettings.BtEnablePex))
            onClicked: {
                App.settings.dmcore.setValue(DmCoreSettings.BtEnablePex,
                                             App.settings.fromBool(checked));
                pexRestartRequired.visible = true;
            }
        }
        RestartRequiredLabel {
            id: pexRestartRequired
            visible: false
            anchors.left: parent.left
            anchors.leftMargin: 20*appWindow.zoom
        }

        SettingsCheckBox
        {
            text: App.my_BT_qsTranslate("Settings", "Enable Local Peer Discovery to find more peers") + App.loc.emptyString
            checked: App.settings.toBool(App.settings.dmcore.value(DmCoreSettings.BtEnableLsd))
            onClicked: App.settings.dmcore.setValue(DmCoreSettings.BtEnableLsd,
                                                    App.settings.fromBool(checked))
        }
    }

    SettingsGroupColumn
    {
        anchors.left: parent.left
        width: parent.width

        SettingsSubgroupHeader
        {
            anchors.left: parent.left
            text: qsTr("Advanced") + App.loc.emptyString
        }

        SettingsCheckBox
        {
            text: App.my_BT_qsTranslate("Settings", "Enable uTP") + App.loc.emptyString
            checked: App.settings.toBool(App.settings.dmcore.value(DmCoreSettings.BtEnableUtp))
            onClicked: App.settings.dmcore.setValue(DmCoreSettings.BtEnableUtp,
                                                    App.settings.fromBool(checked))
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

        SettingsSubgroupHeader {
            anchors.left: parent.left
            visible: useSystemDefinedPort.checked && btTools.item.sessionPort > 0
            text: qsTr("Current port: %1").arg(btTools.item.sessionPort) + App.loc.emptyString
            leftPadding: qtbug.leftPadding(40*appWindow.zoom, 0)
            rightPadding: qtbug.rightPadding(40*appWindow.zoom, 0)
            font.pixelSize: 12*appWindow.fontZoom
        }

        Row {
            visible: !useSystemDefinedPort.checked
            anchors.left: parent.left
            leftPadding: qtbug.leftPadding(40*appWindow.zoom, 0)
            rightPadding: qtbug.rightPadding(40*appWindow.zoom, 0)
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

            anchors.left: parent.left
            anchors.leftMargin: 32*appWindow.zoom

            width: parent.width - 32*appWindow.zoom

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
                height: 150*appWindow.fontZoom
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
