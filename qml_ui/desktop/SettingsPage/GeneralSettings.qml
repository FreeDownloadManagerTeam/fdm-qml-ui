import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import "../../qt5compat"
import org.freedownloadmanager.fdm 1.0
import org.freedownloadmanager.fdm.dmcoresettings 1.0
import org.freedownloadmanager.fdm.appsettings 1.0
import org.freedownloadmanager.fdm.appfeatures 1.0
import "../BaseElements"

import Qt.labs.platform 1.0 as QtLabs

Column {
    spacing: 0

    SettingsGroupHeader {
        text: qsTr("General") + App.loc.emptyString
    }

    SettingsGroupColumn {

        SettingsSubgroupHeader{
            text: qsTr("Choose theme") + App.loc.emptyString
        }

        ThemeComboBox {
            anchors.left: parent.left
            anchors.leftMargin: 16
        }

        BaseLabel {
            text: qsTr("A light theme will be used, if the system theme is unknown.") + App.loc.emptyString
            anchors.left: parent.left
            anchors.leftMargin: 16
            font.pixelSize: 12
            visible: uiSettingsTools.settings.theme === 'system'
        }
    }

    SettingsGroupColumn {

        SettingsSubgroupHeader{
            text: qsTr("Language") + App.loc.emptyString
        }

        LanguageComboBox {}

        BaseHyperLabel {
            text: qsTr("Your language is not listed or the translation isn't complete?") + " <a href='https://github.com/FreeDownloadManagerTeam/FDM6-localization'>" + qsTr("Let's fix it!") + "</a>" + App.loc.emptyString
            anchors.left: parent.left
            anchors.leftMargin: 16
            font.pixelSize: 12
        }
    }

    SettingsGroupColumn {

        SettingsSubgroupHeader {
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
            anchors.leftMargin: 34
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
            anchors.leftMargin: 34
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
            spacing: 10

            DownloadFolderComboBox {
                id: fixedDownloadFolder
                enabled: fixedFolderRadioBtn.checked
                initialPath: App.localDecodePath(App.settings.dmcore.value(DmCoreSettings.FixedDownloadPath))
                onValidPathChanged2: apply()
                function apply() {
                    App.settings.dmcore.setValue(
                        DmCoreSettings.FixedDownloadPath, App.localEncodePath(validPath.trim()));
                }
            }

            CustomButton {
                id: folderBtn
                implicitWidth: 38
                implicitHeight: 25
                enabled: fixedFolderRadioBtn.checked
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
                    folder: App.tools.urlFromLocalFile(App.localDecodePath(App.settings.dmcore.value(DmCoreSettings.FixedDownloadPath))).url
                    acceptLabel: qsTr("Open") + App.loc.emptyString
                    rejectLabel: qsTr("Cancel") + App.loc.emptyString
                    onAccepted: fixedDownloadFolder.editText = App.tools.url(folder).toLocalFile()
                }
            }

            CustomButton {
                text: qsTr("Macros") + App.loc.emptyString
                enabled: fixedFolderRadioBtn.checked
                onClicked: macrosMenu.open()

                MacrosMenu {
                    id: macrosMenu
                    onMacroSelected: { fixedDownloadFolder.editText += macro; }
                }
            }
        }
    }

    SettingsGroupColumn {

        SettingsSubgroupHeader {
            text: qsTr("Downloads") + App.loc.emptyString
        }

        SettingsCheckBox {
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
            text: qsTr("Automatically remove completed downloads from download list") + App.loc.emptyString
            checked: App.settings.toBool(App.settings.dmcore.value(DmCoreSettings.AutoRemoveFinishedDownloads))
            onClicked: {
                App.settings.dmcore.setValue(
                            DmCoreSettings.AutoRemoveFinishedDownloads,
                            App.settings.fromBool(checked));
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


    }

    SettingsGroupColumn {
        Row {
            spacing: 5

            SettingsSubgroupHeader {
                id: batchDownloadLimit
                text: qsTr("Maximum urls count in batch download") + App.loc.emptyString
                anchors.verticalCenter: parent.verticalCenter
            }

            SettingsTextField {
                implicitWidth: 60
                inputMethodHints: Qt.ImhDigitsOnly
                validator: QtRegExpValidator { regExp: /\d+/ }
                text: uiSettingsTools.settings.batchDownloadMaxUrlsCount
                onTextChanged: {
                    if (parseInt(text) > 0) {
                        uiSettingsTools.settings.batchDownloadMaxUrlsCount = parseInt(text);
                    }
                }
            }
        }
    }

    SettingsGroupColumn {
        visible: App.features.hasFeature(AppFeatures.Updates)

        SettingsSubgroupHeader {
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
