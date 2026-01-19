import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs
import "../../common"
import org.freedownloadmanager.fdm
import org.freedownloadmanager.fdm.dmcoresettings
import org.freedownloadmanager.fdm.appsettings
import org.freedownloadmanager.fdm.appfeatures
import "../BaseElements"

Column {
    spacing: 0

    SettingsGroupHeader {
        text: qsTr("General") + App.loc.emptyString
    }

    component VNLayout : GridLayout {
        anchors.left: parent.left

        rowSpacing: parent.spacing
        columnSpacing: 16*appWindow.zoom

        rows: appWindow.uiver === 1 ? 100 : 1
        columns: appWindow.uiver === 1 ? 1 : 100
    }

    SettingsGroupColumn {

        anchors.left: parent.left

        VNLayout
        {
            SettingsSubgroupHeader{
                id: themeLabel
                text: qsTr("Theme") + App.loc.emptyString
                Layout.preferredWidth: Math.max(implicitWidth, uiverLabel.implicitWidth, languageLabel.implicitWidth)
            }

            ThemeComboBox {
                Layout.leftMargin: parent.columns === 1 ? 16*appWindow.zoom : 0
            }
        }

        BaseLabel {
            text: qsTr("A light theme will be used, if the system theme is unknown.") + App.loc.emptyString
            anchors.left: parent.left
            anchors.leftMargin: 16*appWindow.zoom
            font.pixelSize: 12*appWindow.fontZoom
            visible: uiSettingsTools.settings.theme === 'system'
        }

        VNLayout
        {
            SettingsSubgroupHeader{
                id: uiverLabel
                text: qsTr("UI style") + App.loc.emptyString
                Layout.preferredWidth: Math.max(implicitWidth, themeLabel.implicitWidth, languageLabel.implicitWidth)
            }

            BaseComboBox {
                Layout.leftMargin: parent.columns === 1 ? 16*appWindow.zoom : 0
                settingsStyle: true
                model: [
                    {text: qsTr("New") + App.loc.emptyString, value: 2},
                    {text: qsTr("Classic") + App.loc.emptyString, value: 1}
                ]
                currentIndex: {
                    for (let i = 0; i < model.length; ++i) {
                        if (model[i].value === uiSettingsTools.settings.uiVersion)
                            return i;
                    }
                    return -1;
                }
                onActivated: (index) => {
                                 uiSettingsTools.settings.showUiUpdatedBanner = false;
                                 uiSettingsTools.settings.uiVersion = model[index].value;
                             }
            }
        }

        VNLayout
        {
            SettingsSubgroupHeader{
                id: languageLabel
                text: qsTr("Language") + App.loc.emptyString
                Layout.preferredWidth: Math.max(implicitWidth, uiverLabel.implicitWidth, themeLabel.implicitWidth)
            }

            Row {
                Layout.leftMargin: parent.columns === 1 ? 16*appWindow.zoom : 0
                spacing: 30*appWindow.zoom

                LanguageComboBox {}

                RestartRequiredLabel {
                    visible: App.loc.needRestart
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }

        BaseHyperLabel {
            anchors.left: parent.left
            anchors.leftMargin: 16*appWindow.zoom
            text: qsTr("Your language is not listed or the translation isn't complete?") + " <a href='https://github.com/FreeDownloadManagerTeam/FDM6-localization'>" + qsTr("Let's fix it!") + "</a>" + App.loc.emptyString
            font.pixelSize: (appWindow.uiver === 1 ? 12 : appWindow.theme_v2.fontSize)*appWindow.fontZoom
        }
    }

    SettingsGroupColumn {

        anchors.left: parent.left
        width: parent.width

        SettingsSubgroupHeader{
            anchors.left: parent.left
            text: qsTr("Options") + App.loc.emptyString
        }

        SettingsCheckBox {
            text: qsTr("Launch at startup (minimized)") + App.loc.emptyString
            checked: App.autorunEnabled()
            onClicked: App.enableAutorun(checked)
            visible: App.features.hasFeature(AppFeatures.Autorun)
        }
    }

    SettingsGroupColumn {

        anchors.left: parent.left
        width: parent.width

        SettingsSubgroupHeader {
            anchors.left: parent.left
            text: qsTr("Default download folder") + App.loc.emptyString
        }

        SettingsRadioButton {
            id: autoFolderRadioBtn
            text: qsTr("Choose default download folder automatically") + App.loc.emptyString
            checked: !fixedFolderRadioBtn.checked
            onCheckedChanged: {
                if (checked)
                    App.settings.dmcore.setValue(DmCoreSettings.FixedDownloadPath, "");
            }
        }

        SettingsCheckBox {
            text: qsTr("Suggest folders based on file type") + App.loc.emptyString
            enabled: autoFolderRadioBtn.checked
            checked: App.settings.toBool(App.settings.dmcore.value(DmCoreSettings.DownloadPathDependsOnFileType))
            anchors.leftMargin: 34*appWindow.zoom
            onClicked: {
                App.settings.dmcore.setValue(
                            DmCoreSettings.DownloadPathDependsOnFileType,
                            App.settings.fromBool(checked));
            }
        }

        SettingsCheckBox {
            text: qsTr("Suggest folders based on download URL") + App.loc.emptyString
            enabled: autoFolderRadioBtn.checked
            checked: App.settings.toBool(App.settings.dmcore.value(DmCoreSettings.DownloadPathDependsOnSourceUrl))
            anchors.leftMargin: 34*appWindow.zoom
            onClicked: {
                App.settings.dmcore.setValue(
                            DmCoreSettings.DownloadPathDependsOnSourceUrl,
                            App.settings.fromBool(checked));
            }
        }

        SettingsRadioButton {
            id: fixedFolderRadioBtn
            text: qsTr("Fixed default download folder") + App.loc.emptyString
            checked: App.settings.dmcore.value(DmCoreSettings.FixedDownloadPath).length > 0
            onCheckedChanged: {
                if (checked && fixedDownloadFolder.validPath)
                    fixedDownloadFolder.apply()
            }
        }

        RowLayout {
            spacing: 10*appWindow.zoom
            width: parent.width - 20*appWindow.zoom

            DownloadFolderComboBox {
                id: fixedDownloadFolder
                enabled: fixedFolderRadioBtn.checked
                Layout.fillWidth: true
                Layout.maximumWidth: 1000*appWindow.zoom
                initialPath: App.localDecodePath(App.settings.dmcore.value(DmCoreSettings.FixedDownloadPath))
                onValidPathChanged2: apply()
                function apply() {
                    if (fixedFolderRadioBtn.checked)
                    {
                        App.settings.dmcore.setValue(
                            DmCoreSettings.FixedDownloadPath, App.localEncodePath(validPath.trim()));
                    }
                }
            }

            PickFileButton {
                id: folderBtn
                enabled: fixedFolderRadioBtn.checked
                Layout.preferredHeight: fixedDownloadFolder.height
                onClicked: browseDlg.open()
                FolderDialog {
                    id: browseDlg
                    currentFolder: App.tools.urlFromLocalFile(App.localDecodePath(App.settings.dmcore.value(DmCoreSettings.FixedDownloadPath))).url
                    acceptLabel: qsTr("Open") + App.loc.emptyString
                    rejectLabel: qsTr("Cancel") + App.loc.emptyString
                    onAccepted: fixedDownloadFolder.editText = App.toNativeSeparators(App.tools.url(currentFolder).toLocalFile())
                }
            }

            BaseButton {
                text: qsTr("Macros") + App.loc.emptyString
                enabled: fixedFolderRadioBtn.checked
                Layout.preferredHeight: fixedDownloadFolder.height
                onClicked: macrosMenu.open()

                MacrosMenu {
                    id: macrosMenu
                    onMacroSelected: macro => { fixedDownloadFolder.editText += macro; }
                }
            }

            Item {Layout.fillWidth: true; implicitHeight: 1}
        }
    }

    SettingsGroupColumn {

        anchors.left: parent.left

        SettingsSubgroupHeader {
            anchors.left: parent.left
            text: qsTr("Downloads") + App.loc.emptyString
        }

        SettingsCheckBox {
            visible: appWindow.uiver === 1
            text: qsTr("Compact view of downloads list") + App.loc.emptyString
            checked: uiSettingsTools.settings.compactView
            onClicked: { uiSettingsTools.settings.compactView = !uiSettingsTools.settings.compactView }
        }

        SettingsCheckBox {
            text: qsTr("Enable standalone downloads windows") + App.loc.emptyString
            checked: uiSettingsTools.settings.enableStandaloneDownloadsWindows
            onClicked: { uiSettingsTools.settings.enableStandaloneDownloadsWindows = !uiSettingsTools.settings.enableStandaloneDownloadsWindows }
        }

        SettingsCheckBox {
            text: qsTr("Automatically remove deleted files from download list") + App.loc.emptyString
            checked: downloadsWithMissingFilesTools.autoRemoveDownloads
            onClicked: downloadsWithMissingFilesTools.autoRemoveDownloads = checked
        }

        SettingsCheckBox {
            id: removeFinished
            text: qsTr("Automatically remove completed downloads from download list") + App.loc.emptyString
            checked: App.settings.toBool(App.settings.dmcore.value(DmCoreSettings.AutoRemoveFinishedDownloads))
            onClicked: {
                App.settings.dmcore.setValue(
                            DmCoreSettings.AutoRemoveFinishedDownloads,
                            App.settings.fromBool(checked));
            }
        }

        Row {
            visible: removeFinished.checked
            anchors.left: parent.left
            leftPadding: qtbug.leftPadding(40*appWindow.zoom,0)
            rightPadding: qtbug.rightPadding(40*appWindow.zoom,0)
            spacing: 3*appWindow.fontZoom

            BaseRadioButton {
                id: removeFinishedImmediately
                text: qsTr("Immediately") + App.loc.emptyString
                textColor: appWindow.theme.settingsItem
                checked: !parseInt(App.settings.dmcore.value(DmCoreSettings.AutoRemoveFinishedDownloads_KeepDays))
                anchors.verticalCenter: parent.verticalCenter
                onClicked: {
                    App.settings.dmcore.setValue(
                                DmCoreSettings.AutoRemoveFinishedDownloads_KeepDays,
                                "0");
                }
            }

            Item {
                implicitWidth: 15*appWindow.fontZoom
                implicitHeight: 1
            }

            BaseRadioButton {
                id: removeFinishedIn
                checked: !removeFinishedImmediately.checked
                //: Automatically remove finished downloads In N days
                text: qsTr("In") + App.loc.emptyString
                textColor: appWindow.theme.settingsItem
                anchors.verticalCenter: parent.verticalCenter
                onClicked: {
                    if (removeFinishedInDays.text)
                    {
                        App.settings.dmcore.setValue(
                                    DmCoreSettings.AutoRemoveFinishedDownloads_KeepDays,
                                    removeFinishedInDays.text);
                    }
                    else
                    {
                        removeFinishedInDays.forceActiveFocus();
                    }
                }
            }

            SettingsTextField {
                id: removeFinishedInDays
                enabled: removeFinishedIn.checked
                text: parseInt(App.settings.dmcore.value(DmCoreSettings.AutoRemoveFinishedDownloads_KeepDays)) ?
                          App.settings.dmcore.value(DmCoreSettings.AutoRemoveFinishedDownloads_KeepDays) :
                          ""
                implicitWidth: 40*appWindow.fontZoom
                inputMethodHints: Qt.ImhDigitsOnly
                validator: RegularExpressionValidator { regularExpression: /[1-9]\d*/ }
                anchors.verticalCenter: parent.verticalCenter
                onActiveFocusChanged: {
                    if (!activeFocus && removeFinishedIn.checked && text)
                    {
                        App.settings.dmcore.setValue(
                                    DmCoreSettings.AutoRemoveFinishedDownloads_KeepDays,
                                    text);
                    }
                }
            }

            SettingsGridLabel {
                enabled: removeFinishedIn.checked
                //: Automatically remove finished downloads In N days
                text: qsTr("days") + App.loc.emptyString
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        SettingsCheckBox {
            text: qsTr("Automatically retry failed downloads") + App.loc.emptyString
            checked: App.settings.toBool(App.settings.dmcore.value(DmCoreSettings.AutoRetryFailedDownloads))
            onClicked: {
                App.settings.dmcore.setValue(
                            DmCoreSettings.AutoRetryFailedDownloads,
                            App.settings.fromBool(checked));
            }
        }

        SettingsCheckBox {
            text: qsTr("Do not download web pages") + App.loc.emptyString
            checked: App.settings.toBool(App.settings.dmcore.value(DmCoreSettings.DetectUnwantedDownloadErrors))
            onClicked: {
                App.settings.dmcore.setValue(
                            DmCoreSettings.DetectUnwantedDownloadErrors,
                            App.settings.fromBool(checked));
            }
        }

//        SettingsCheckBox {
//            text: qsTr("Automatically restart finished downloads, if remote resource changed") + App.loc.emptyString
//            checked: App.settings.toBool(App.settings.dmcore.value(DmCoreSettings.AutoRestartFinishedDownloadIfRemoteResourceChanged))
//            onClicked: {
//                App.settings.dmcore.setValue(
//                            DmCoreSettings.AutoRestartFinishedDownloadIfRemoteResourceChanged,
//                            App.settings.fromBool(checked));
//            }
//        }

        SettingsCheckBox {
            text: qsTr("Use server time for file creation") + App.loc.emptyString
            checked: App.settings.toBool(App.settings.dmcore.value(DmCoreSettings.TakeLastModifiedDateFromServer))
            onClicked: {
                App.settings.dmcore.setValue(
                            DmCoreSettings.TakeLastModifiedDateFromServer,
                            App.settings.fromBool(checked));
           }
        }

        Row {
            visible: App.features.hasFeature(AppFeatures.MarkOfTheWeb)

            anchors.left: parent.left
            anchors.leftMargin: 12*appWindow.zoom

            spacing: 8*appWindow.zoom

            SettingsCheckBox0 {
                text: qsTr("Mark downloaded files") + App.loc.emptyString
                checked: App.settings.toBool(App.settings.dmcore.value(DmCoreSettings.SetMarkOfTheWeb))
                onClicked: {
                    App.settings.dmcore.setValue(
                                DmCoreSettings.SetMarkOfTheWeb,
                                App.settings.fromBool(checked));
               }
            }

            BaseHyperLabel {
                text: "<a href='" + App.markOfTheWebFeatureHelpUrl() + "'>?</a>"
            }
        }

        Row {
            anchors.left: parent.left
            anchors.leftMargin: 17*appWindow.zoom

            spacing: 5*appWindow.zoom

            SettingsGridLabel {
                id: batchDownloadLimit
                text: qsTr("Maximum urls count in batch download") + App.loc.emptyString
                anchors.verticalCenter: parent.verticalCenter
            }

            SettingsTextField {
                implicitWidth: 60*appWindow.fontZoom
                inputMethodHints: Qt.ImhDigitsOnly
                validator: RegularExpressionValidator { regularExpression: /[1-9]\d*/ }
                text: uiSettingsTools.settings.batchDownloadMaxUrlsCount
                onTextChanged: {
                    let val = parseInt(text) || 0;
                    if (val > 0 && val < 1000000)
                        uiSettingsTools.settings.batchDownloadMaxUrlsCount = val;
                }
            }
        }
    }

    SettingsGroupColumn {
        visible: App.features.hasFeature(AppFeatures.Updates)
        anchors.left: parent.left

        SettingsSubgroupHeader {
            anchors.left: parent.left
            text: qsTr("Update") + App.loc.emptyString
            visible: App.features.hasFeature(AppFeatures.Updates)
        }

        SettingsCheckBox {
            text: qsTr("Check for updates automatically") + App.loc.emptyString
            checked: App.settings.toBool(App.settings.app.value(AppSettings.CheckUpdatesAutomatically))
            onClicked: {
                App.settings.app.setValue(
                            AppSettings.CheckUpdatesAutomatically,
                            App.settings.fromBool(checked));
            }
        }

        SettingsCheckBox {
            text: qsTr("Install updates automatically") + App.loc.emptyString
            checked: App.settings.toBool(App.settings.app.value(AppSettings.InstallUpdatesAutomatically))
            onClicked: {
                App.settings.app.setValue(
                            AppSettings.InstallUpdatesAutomatically,
                            App.settings.fromBool(checked));
            }
        }
    }
}
