import QtQuick 2.10
import QtQuick.Controls 2.3
import Qt.labs.settings 1.0
import "../../qt5compat"
import org.freedownloadmanager.fdm 1.0
import org.freedownloadmanager.fdm.dmcoresettings 1.0
import org.freedownloadmanager.fdm.appsettings 1.0
import org.freedownloadmanager.fdm.appfeatures 1.0
import org.freedownloadmanager.fdm.abstractdownloadsui 1.0
import "../BaseElements"
import "../Dialogs"

Column
{
    id: root

    spacing: 0
    width: parent.width

    property alias hidden: header.hidden

    SettingsGroupHeader {
        id: header
        text: qsTr("Advanced") + App.loc.emptyString
        /*enableHideButton: true
        hidden: true*/
    }

    SettingsGroupColumn {
        visible: !root.hidden && App.features.hasFeature(AppFeatures.SystemNotifications)
        width: parent.width

        SettingsSubgroupHeader {
            text: qsTr("Notifications") + App.loc.emptyString
            visible: App.features.hasFeature(AppFeatures.SystemNotifications)
        }

        SettingsCheckBox {
            text: qsTr("Notify me of added downloads via Notification Center") + App.loc.emptyString
            checked: App.settings.toBool(App.settings.app.value(AppSettings.NotifyOfAddedDownloads))
            width: parent.width
            onClicked: {
                App.settings.app.setValue(
                            AppSettings.NotifyOfAddedDownloads,
                            App.settings.fromBool(checked));
            }
        }

        SettingsCheckBox {
            text: qsTr("Notify me of completed downloads via Notification Center") + App.loc.emptyString
            checked: App.settings.toBool(App.settings.app.value(AppSettings.NotifyOfFinishedDownloads))
            width: parent.width
            onClicked: {
                App.settings.app.setValue(
                            AppSettings.NotifyOfFinishedDownloads,
                            App.settings.fromBool(checked));
            }
        }

        SettingsCheckBox {
            text: qsTr("Notify me of failed downloads via Notification Center") + App.loc.emptyString
            checked: App.settings.toBool(App.settings.app.value(AppSettings.NotifyOfFailedDownloads))
            width: parent.width
            onClicked: {
                App.settings.app.setValue(
                            AppSettings.NotifyOfFailedDownloads,
                            App.settings.fromBool(checked));
            }
        }

        SettingsCheckBox {
            text: qsTr("Notify me of downloads only when %1 window is inactive").arg(App.shortDisplayName) + App.loc.emptyString
            checked: App.settings.toBool(App.settings.app.value(AppSettings.NotifyOfDownloadsWhenAppInactiveOnly))
            onClicked: {
                App.settings.app.setValue(
                            AppSettings.NotifyOfDownloadsWhenAppInactiveOnly,
                            App.settings.fromBool(checked));
            }
        }

        Rectangle {
            width: parent.width
            height: useSounds.height
            color: "transparent"

            SettingsCheckBox {
                id: useSounds
                text: qsTr("Use sounds") + App.loc.emptyString
                checked: App.settings.toBool(App.settings.app.value(AppSettings.EnableSoundNotifications))
                onClicked: {
                    App.settings.app.setValue(
                                AppSettings.EnableSoundNotifications,
                                App.settings.fromBool(checked));
                }
            }

            Rectangle {
                anchors.left: useSounds.right
                anchors.leftMargin: 5
                anchors.verticalCenter: parent.verticalCenter
                width: 16
                height: width
                color: "transparent"

                Image {
                    source: Qt.resolvedUrl("../../images/desktop/edit_list.png")
                    sourceSize.width: 16
                    sourceSize.height: 16
                    opacity: useSounds.checked ? 1 : 0.5
                    layer {
                        effect: ColorOverlay {
                            color: appWindow.theme.foreground
                        }
                        enabled: true
                    }
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        hoverEnabled: true
                        onClicked: { if (useSounds.checked) customizeSoundsDlg.open() }
                        onEntered: toolTipHosts.visible = true
                        onExited: toolTipHosts.visible = false

                        BaseToolTip {
                            id: toolTipHosts
                            text: qsTr("Customize sounds") + App.loc.emptyString
                        }
                    }
                }
            }
        }
    }

    SettingsGroupColumn {
        visible: !root.hidden && App.features.hasFeature(AppFeatures.PreventOsAutoSleep)

        SettingsSubgroupHeader {
            text: qsTr("Power management") + App.loc.emptyString
            visible: App.features.hasFeature(AppFeatures.PreventOsAutoSleep)
        }

        SettingsCheckBox {
            text: qsTr("Don't put your computer to sleep if there is an active download") + App.loc.emptyString
            checked: App.settings.toBool(App.settings.dmcore.value(DmCoreSettings.PreventOsAutoSleepIfDownloadsRunning))
            onClicked: {
                App.settings.dmcore.setValue(
                            DmCoreSettings.PreventOsAutoSleepIfDownloadsRunning,
                            App.settings.fromBool(checked));
            }
        }

        SettingsCheckBox {
            text: qsTr("Enable sleep mode while running finished downloads") + App.loc.emptyString
            checked: App.settings.toBool(App.settings.dmcore.value(DmCoreSettings.PreventOsAutoSleepIfDownloadsRunning_IgnoreFinished))
            onClicked: {
                App.settings.dmcore.setValue(
                            DmCoreSettings.PreventOsAutoSleepIfDownloadsRunning_IgnoreFinished,
                            App.settings.fromBool(checked));
            }
        }
    }

    SettingsGroupColumn {

        visible: !root.hidden

        SettingsSubgroupHeader{
            text: qsTr("Options") + App.loc.emptyString
        }

        SettingsCheckBox {
            text: qsTr("Launch at startup (minimized)") + App.loc.emptyString
            checked: App.autorunEnabled()
            onClicked: App.enableAutorun(checked)
            visible: App.features.hasFeature(AppFeatures.Autorun)
        }

        Rectangle {
            width: parent.width
            height: backupCheckbox.height
            color: "transparent"

            SettingsCheckBox {
                id: backupCheckbox
                text: qsTr("Backup the list of downloads every") + App.loc.emptyString
                checked: App.settings.dbBackupMinInterval() != -1
                onClicked: {
                    if (checked) {
                        App.settings.setDbBackupMinInterval(backupCombo.model[backupCombo.currentIndex].value);
                    } else {
                        App.settings.setDbBackupMinInterval(-1);
                    }
                }
            }

            BackupComboBox {
                id: backupCombo
                enabled: backupCheckbox.checked
                anchors.left: backupCheckbox.right
                anchors.leftMargin: 5
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        SettingsCheckBox {
            text: qsTr("Do not allow downloads to perform post finished tasks when running on battery") + App.loc.emptyString
            visible: App.features.hasFeature(AppFeatures.Battery)
            checked: App.settings.dmcore.value(DmCoreSettings.DisablePostFinishedTasksOnBattery)
            onClicked: { App.settings.dmcore.setValue(
                             DmCoreSettings.DisablePostFinishedTasksOnBattery,
                             App.settings.fromBool(checked));
            }
        }

        Rectangle {
            visible: App.features.hasFeature(AppFeatures.Battery)
            width: parent.width
            height: batteryCheckbox.height
            color: "transparent"

            SettingsCheckBox {
                id: batteryCheckbox
                text: qsTr("Do not allow downloads if battery level drops below") + App.loc.emptyString
                checked: App.settings.dmcore.value(DmCoreSettings.BatteryMinimumPowerLevelToRunDownloads) > 0
                onClicked: {
                    if (checked) {
                        batteryCombo.saveBatteryMinimumPowerLevelToRunDownloads(batteryCombo.currentText);
                    } else {
                        batteryCombo.saveBatteryMinimumPowerLevelToRunDownloads(0);
                    }
                }
            }

            BatteryComboBox {
                id: batteryCombo
                enabled: batteryCheckbox.checked
                anchors.left: batteryCheckbox.right
                anchors.leftMargin: 5
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        SettingsCheckBox {
            text: qsTr("Show special offers") + App.loc.emptyString
            checked: App.settings.toBool(App.settings.app.value(AppSettings.ShowSpecialOffers))
            onClicked: { App.settings.app.setValue(
                             AppSettings.ShowSpecialOffers,
                             App.settings.fromBool(checked));
            }
        }
    }

    SettingsGroupColumn {

        visible: !root.hidden

        SettingsSubgroupHeader{
            text: qsTr("Interface") + App.loc.emptyString
        }

        SettingsCheckBox {
            text: qsTr("Open/hide the bottom panel by clicking on the download") + App.loc.emptyString
            checked: uiSettingsTools.settings.toggleBottomPanelByClickingOnDownload
            onClicked: { uiSettingsTools.settings.toggleBottomPanelByClickingOnDownload = !uiSettingsTools.settings.toggleBottomPanelByClickingOnDownload }
        }

        Loader {
            width: parent.width
            active: appWindow.macVersion
            source: "DockUploadSpeedSetting.qml"
        }

        SettingsCheckBox {
            text: qsTr("Indicate active download and upload using tray icon") + App.loc.emptyString
            checked: App.settings.toBool(App.settings.app.value(AppSettings.IndicateDownloadAndUploadUsingTrayIcon))
            onClicked: App.settings.app.setValue(AppSettings.IndicateDownloadAndUploadUsingTrayIcon,
                                                 App.settings.fromBool(checked))
        }

        SettingsCheckBox {
            text: qsTr("Enable user defined order of downloads") + App.loc.emptyString
            checked: uiSettingsTools.settings.enableUserDefinedOrderOfDownloads
            onClicked: uiSettingsTools.settings.enableUserDefinedOrderOfDownloads = checked
        }

        SettingsCheckBox {
            text: qsTr("Show \"Save As...\" button") + App.loc.emptyString
            checked: uiSettingsTools.settings.showSaveAsButton
            onClicked: uiSettingsTools.settings.showSaveAsButton = checked
        }

        SettingsCheckBox {
            text: qsTr("Restore hidden state when finished adding new downloads") + App.loc.emptyString
            checked: uiSettingsTools.settings.autoHideWhenFinishedAddingDownloads
            onClicked: uiSettingsTools.settings.autoHideWhenFinishedAddingDownloads = checked
        }
    }

    SettingsGroupColumn {

        visible: !root.hidden

        SettingsSubgroupHeader{
            text: qsTr("Delete button action") + App.loc.emptyString
        }

        SettingsRadioButton {
            text: qsTr("Remove only from download list") + App.loc.emptyString
            checked: uiSettingsTools.settings.deleteButtonAction === 2
            onClicked: uiSettingsTools.settings.deleteButtonAction = 2
        }
        SettingsRadioButton {
            text: qsTr("Delete files") + App.loc.emptyString
            checked: uiSettingsTools.settings.deleteButtonAction === 1
            onClicked: uiSettingsTools.settings.deleteButtonAction = 1
        }
        SettingsRadioButton {
            text: qsTr("Always ask") + App.loc.emptyString
            checked: uiSettingsTools.settings.deleteButtonAction === 0
            onClicked: uiSettingsTools.settings.deleteButtonAction = 0
        }
    }

    SettingsGroupColumn {
        id: existingFileReactionGroup

        property int existingFileReaction: App.settings.dmcore.value(DmCoreSettings.ExistingFileReaction)

        visible: !root.hidden

        SettingsSubgroupHeader{
            text: qsTr("File exists reaction") + App.loc.emptyString
        }

        SettingsRadioButton {
            text: qsTr("Rename") + App.loc.emptyString
            checked: existingFileReactionGroup.existingFileReaction == AbstractDownloadsUi.DefrRename
            onClicked: existingFileReactionGroup.setFileExistsReaction(AbstractDownloadsUi.DefrRename)
        }
        SettingsRadioButton {
            text: qsTr("Overwrite") + App.loc.emptyString
            checked: existingFileReactionGroup.existingFileReaction == AbstractDownloadsUi.DefrOverwrite
            onClicked: existingFileReactionGroup.setFileExistsReaction(AbstractDownloadsUi.DefrOverwrite)
        }
        SettingsRadioButton {
            text: qsTr("Always ask") + App.loc.emptyString
            checked: existingFileReactionGroup.existingFileReaction == AbstractDownloadsUi.DefrAsk
            onClicked: existingFileReactionGroup.setFileExistsReaction(AbstractDownloadsUi.DefrAsk)
        }

        function setFileExistsReaction(value) {
            App.settings.dmcore.setValue(DmCoreSettings.ExistingFileReaction, value);
        }
    }

    SettingsGroupColumn {
        id: resetToDefaults

        SettingsSubgroupHeader{
            text: qsTr("Go back to default settings") + App.loc.emptyString
        }

        CustomButton {
            text: qsTr("Reset") + App.loc.emptyString
            enabled: App.settings.hasNonDefaultValues || uiSettingsTools.hasNonDefaultValues
            onClicked: okToResetMsg.open()
            blueBtn: true
            anchors.left: parent.left
            anchors.leftMargin: 20
            MessageDialog
            {
                id: okToResetMsg
                title: qsTr("Default settings") + App.loc.emptyString
                text: qsTr("Restore default settings?") + App.loc.emptyString
                buttons: buttonOk | buttonCancel
                onAccepted: {
                    App.settings.resetToDefaults();
                    uiSettingsTools.resetToDefaults();
                    stackView.pop();
                    appWindow.openSettings();
                }
            }
        }
    }
}
