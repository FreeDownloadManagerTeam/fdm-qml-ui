import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import Qt.labs.platform 1.1
import Qt.labs.settings 1.0
import "../../qt5compat"
import "../../common"
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
        anchors.left: parent.left

        SettingsSubgroupHeader {
            anchors.left: parent.left
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
                anchors.leftMargin: 5*appWindow.zoom
                anchors.verticalCenter: parent.verticalCenter
                width: 16*appWindow.zoom
                height: width
                color: "transparent"

                WaSvgImage {
                    zoom: appWindow.zoom
                    source: Qt.resolvedUrl("../../images/desktop/edit_list.svg")
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
        anchors.left: parent.left

        SettingsSubgroupHeader {
            anchors.left: parent.left
            text: qsTr("Power management") + App.loc.emptyString
            visible: App.features.hasFeature(AppFeatures.PreventOsAutoSleep)
        }

        SettingsCheckBox {
            id: preventSleepBox
            text: qsTr("Avoid sleep mode if there is an active download") + App.loc.emptyString
            checked: App.settings.toBool(App.settings.dmcore.value(DmCoreSettings.PreventOsAutoSleepIfDownloadsRunning))
            onClicked: App.settings.dmcore.setValue(
                           DmCoreSettings.PreventOsAutoSleepIfDownloadsRunning,
                           App.settings.fromBool(checked))
        }

        SettingsCheckBox {
            enabled: preventSleepBox.checked
            anchors.leftMargin: 35*appWindow.zoom
            text: qsTr("Avoid sleep mode if there is a scheduled download") + App.loc.emptyString
            checked: App.settings.toBool(App.settings.dmcore.value(DmCoreSettings.PreventOsAutoSleepIfDownloadsRunning_IncludingScheduled))
            onClicked: App.settings.dmcore.setValue(
                           DmCoreSettings.PreventOsAutoSleepIfDownloadsRunning_IncludingScheduled,
                           App.settings.fromBool(checked))
        }

        SettingsCheckBox {
            enabled: preventSleepBox.checked
            anchors.leftMargin: 35*appWindow.zoom
            text: qsTr("Allow sleep mode if downloads can be resumed later") + App.loc.emptyString
            checked: App.settings.toBool(App.settings.dmcore.value(DmCoreSettings.PreventOsAutoSleepIfDownloadsRunning_IgnoreDownloadsWithResumeSupport))
            onClicked: App.settings.dmcore.setValue(
                           DmCoreSettings.PreventOsAutoSleepIfDownloadsRunning_IgnoreDownloadsWithResumeSupport,
                           App.settings.fromBool(checked))
        }

        SettingsCheckBox {
            enabled: preventSleepBox.checked
            anchors.leftMargin: 35*appWindow.zoom
            text: qsTr("Allow sleep mode while sharing files") + App.loc.emptyString
            checked: App.settings.toBool(App.settings.dmcore.value(DmCoreSettings.PreventOsAutoSleepIfDownloadsRunning_IgnoreFinished))
            onClicked: App.settings.dmcore.setValue(
                           DmCoreSettings.PreventOsAutoSleepIfDownloadsRunning_IgnoreFinished,
                           App.settings.fromBool(checked))
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
                anchors.leftMargin: 5*appWindow.zoom
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        SettingsCheckBox {
            text: qsTr("Do not share files when running on battery") + App.loc.emptyString
            visible: App.features.hasFeature(AppFeatures.Battery)
            checked: App.settings.toBool(App.settings.dmcore.value(DmCoreSettings.DisablePostFinishedTasksOnBattery))
            onClicked: { App.settings.dmcore.setValue(
                             DmCoreSettings.DisablePostFinishedTasksOnBattery,
                             App.settings.fromBool(checked));
            }
        }
    }

    SettingsGroupColumn {

        visible: !root.hidden
        anchors.left: parent.left

        SettingsSubgroupHeader{
            anchors.left: parent.left
            text: qsTr("Options") + App.loc.emptyString
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
                anchors.leftMargin: 5*appWindow.zoom
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
        anchors.left: parent.left

        SettingsSubgroupHeader{
            text: qsTr("Interface") + App.loc.emptyString
            anchors.left: parent.left
        }

        SettingsCheckBox {
            text: qsTr("Click on the Close button to hide %1 and keep it running in the background").arg(App.shortDisplayName) + App.loc.emptyString
            checked: uiSettingsTools.settings.closeButtonHidesApp
            onClicked: { uiSettingsTools.settings.closeButtonHidesApp = !uiSettingsTools.settings.closeButtonHidesApp }
        }

        SettingsCheckBox {
            text: qsTr("Open/hide the bottom panel by clicking on the download") + App.loc.emptyString
            checked: uiSettingsTools.settings.toggleBottomPanelByClickingOnDownload
            onClicked: { uiSettingsTools.settings.toggleBottomPanelByClickingOnDownload = !uiSettingsTools.settings.toggleBottomPanelByClickingOnDownload }
        }

        SettingsCheckBox {
            id: hideDockIcon
            visible: appWindow.macVersion
            text: qsTr("Hide the Dock icon") + App.loc.emptyString
            checked: App.settings.toBool(App.settings.app.value(AppSettings.HideDockIcon))
            onClicked: {
                App.settings.app.setValue(
                            AppSettings.HideDockIcon,
                            App.settings.fromBool(checked));
                if (checked)
                    appWindow.showWindow(); // macOS hides app's main window when the dock icon is removed; so we restore it
            }
        }

        Loader {
            width: parent.width
            active: appWindow.macVersion
            source: "DockUploadSpeedSetting.qml"
            enabled: !hideDockIcon.checked
        }

        SettingsCheckBox {
            text: qsTr("Indicate active download and upload using tray icon") + App.loc.emptyString
            checked: App.settings.toBool(App.settings.app.value(AppSettings.IndicateDownloadAndUploadUsingTrayIcon))
            onClicked: App.settings.app.setValue(AppSettings.IndicateDownloadAndUploadUsingTrayIcon,
                                                 App.settings.fromBool(checked))
        }

        SettingsCheckBox {
            visible: appWindow.uiver === 1
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
            text: qsTr("Enable standalone create new downloads windows") + App.loc.emptyString
            checked: uiSettingsTools.settings.enableStandaloneCreateDownloadsWindows
            onClicked: uiSettingsTools.settings.enableStandaloneCreateDownloadsWindows = checked
        }

        Row {
            anchors.left: parent.left
            anchors.leftMargin: 18*appWindow.zoom

            spacing: 10*appWindow.zoom

            BaseLabel {
                text: qsTr("Show built-in tags:") + App.loc.emptyString
                anchors.verticalCenter: parent.verticalCenter
            }

            Repeater {
                model: tagsTools.systemTags

                delegate: BaseCheckBox {
                    textColor: appWindow.theme.settingsItem
                    text: App.loc.tr(modelData.name)
                    checked: !uiSettingsTools.settings.hideTags[modelData.id]
                    onClicked: {
                        let o = uiSettingsTools.settings.hideTags;
                        o[modelData.id] = !checked;
                        uiSettingsTools.settings.hideTags = o;
                    }
                }
            }
        }

        Column
        {
            anchors.left: parent.left
            anchors.leftMargin: 18*appWindow.zoom
            spacing: 5*appWindow.zoom

            Row {
                spacing: 10*appWindow.zoom

                BaseLabel {
                    text: qsTr("Overall zoom") + App.loc.emptyString
                    anchors.verticalCenter: parent.verticalCenter
                }
                BaseComboBox {
                    settingsStyle: true
                    anchors.verticalCenter: parent.verticalCenter
                    model: [
                        {text: "100%", value: 1.0},
                        {text: "200%", value: 2.0}
                    ]
                    currentIndex: {
                        let z = uiSettingsTools.settings.scheduledZoom ?
                                uiSettingsTools.settings.scheduledZoom :
                                uiSettingsTools.zoom;
                        for (let i = 0; i < model.length; ++i) {
                            if (model[i].value === z)
                                return i;
                        }
                        return 0;
                    }
                    onActivated: (index) => uiSettingsTools.settings.scheduledZoom = model[index].value
                }
                BaseLabel {
                    anchors.verticalCenter: parent.verticalCenter
                    text: qsTr("Fonts zoom") + App.loc.emptyString
                }
                BaseComboBox {
                    settingsStyle: true
                    anchors.verticalCenter: parent.verticalCenter
                    model: [
                        {text: "70%", value: 0.7},
                        {text: "80%", value: 0.8},
                        {text: "90%", value: 0.9},
                        {text: "100%", value: 1.0},
                        {text: "110%", value: 1.1},
                        {text: "120%", value: 1.2},
                        {text: "130%", value: 1.3},
                        {text: "140%", value: 1.4}
                    ]
                    currentIndex: {
                        let z2 = uiSettingsTools.settings.scheduledZoom2 ?
                                uiSettingsTools.settings.scheduledZoom2 :
                                uiSettingsTools.zoom2;
                        for (let i = 0; i < model.length; ++i) {
                            if (model[i].value === z2)
                                return i;
                        }
                        return 0;
                    }
                    onActivated: (index) => uiSettingsTools.settings.scheduledZoom2 = model[index].value
                }
            }

            RestartRequiredLabel {
                visible: (uiSettingsTools.settings.scheduledZoom && uiSettingsTools.settings.scheduledZoom !== appWindow.zoom) ||
                         (uiSettingsTools.settings.scheduledZoom2 && uiSettingsTools.settings.scheduledZoom2 !== appWindow.zoom2)
                anchors.left: parent.left
            }
        }
    }

    SettingsGroupColumn {

        id: automationGroup

        visible: !root.hidden
        anchors.left: parent.left
        width: parent.width

        SettingsSubgroupHeader{
            text: qsTr("Automation") + App.loc.emptyString
            anchors.left: parent.left
        }

        SettingsCheckBox {
            id: launchExternalAppCheckBox
            text: qsTr("Launch external application on download completion") + App.loc.emptyString
            checked: App.settings.toBool(App.settings.dmcore.value(DmCoreSettings.LaunchExternalAppOnDownloadCompletion))
            onClicked: automationGroup.applyLaunchExternalAppSettings()
        }

        GridLayout {

            id: externalAppSettingsGrid

            readonly property bool inError: urlField.inError || args.inError

            enabled: launchExternalAppCheckBox.checked
            anchors.left: parent.left

            columns: 2
            width: Math.min(parent.width, 650*appWindow.zoom)
            rowSpacing: 12*appWindow.zoom

            BaseLabel {
                text: qsTr("Path:") + App.loc.emptyString
                leftPadding: qtbug.leftPadding(38*appWindow.zoom, 10*appWindow.zoom)
                rightPadding: qtbug.rightPadding(38*appWindow.zoom, 10*appWindow.zoom)
                color: appWindow.theme.settingsItem
            }

            RowLayout {
                Layout.preferredHeight: folderBtn.implicitHeight + 1

                SettingsTextField {
                    id: urlField
                    property bool inError: false
                    focus: true
                    Layout.fillWidth: true
                    text: App.settings.dmcore.value(DmCoreSettings.LaunchExternalAppOnDownloadCompletion_AppPath)

                    onTextChanged: urlFieldUpdateStateTimer.restart()
                    Component.onCompleted: urlFieldUpdateStateTimer.start()

                    SettingsInputError {
                        visible: urlField.inError && urlField.activeFocus
                        errorMessage: qsTr("Please enter application's path") + App.loc.emptyString
                    }

                    function updatState() {
                        urlField.inError = text && !App.tools.localFileExists2(text, true);
                        if (!urlField.inError)
                            automationGroup.applyLaunchExternalAppSettings();
                    }

                    Timer {
                        id: urlFieldUpdateStateTimer
                        interval: 300
                        onTriggered: parent.updatState()
                    }
                }

                PickFileButton {
                    id: folderBtn
                    Layout.alignment: Qt.AlignRight
                    implicitHeight: urlField.implicitHeight
                    onClicked: browseDlg.open()
                    FileDialog {
                        id: browseDlg
                        onAccepted: {
                            urlField.text = App.tools.fixExternalApplicationPath(App.tools.url(selectedFile).toLocalFile());
                        }
                    }
                }
            }

            BaseLabel {
                text: qsTr("Arguments:") + App.loc.emptyString
                leftPadding: qtbug.leftPadding(38*appWindow.zoom, 10*appWindow.zoom)
                rightPadding: qtbug.rightPadding(38*appWindow.zoom, 10*appWindow.zoom)
                color: appWindow.theme.settingsItem
            }

            SettingsTextField {
                id: args
                property bool inError: false
                text: App.settings.dmcore.value(DmCoreSettings.LaunchExternalAppOnDownloadCompletion_AppArgsTemplate)
                Layout.fillWidth: true

                onTextChanged: {
                    updatState()
                    if (!args.inError)
                        automationGroup.applyLaunchExternalAppSettings();
                }

                Component.onCompleted: updatState()

                SettingsInputError {
                    id: argsErr
                    visible: args.inError && args.activeFocus
                    errorMessage: qsTr("Arguments must contain %path% variable") + App.loc.emptyString
                }

                function updatState() {
                    argsErr.errorMessage = App.settings.isValidExternalAppArgs(args.text);
                    args.inError = argsErr.errorMessage != '';
                }
            }

            Item {implicitHeight: 1; implicitWidth: 1}

            SettingsGridLabel {
                Layout.topMargin: -7*appWindow.zoom
                text: qsTr("Arguments must contain %path% variable") + App.loc.emptyString
                color: "#999"
            }
        }

        function applyLaunchExternalAppSettings()
        {
            if (externalAppSettingsGrid.inError)
                return;

            let enabled = launchExternalAppCheckBox.checked && urlField.text.length > 0;

            App.settings.dmcore.setValue(
                        DmCoreSettings.LaunchExternalAppOnDownloadCompletion_AppArgsTemplate,
                        args.text);

            App.settings.dmcore.setValue(
                        DmCoreSettings.LaunchExternalAppOnDownloadCompletion_AppPath,
                        urlField.text);

            App.settings.dmcore.setValue(
                        DmCoreSettings.LaunchExternalAppOnDownloadCompletion,
                        App.settings.fromBool(enabled));

        }
    }

    SettingsGroupColumn {

        visible: !root.hidden
        anchors.left: parent.left

        SettingsSubgroupHeader{
            text: qsTr("Delete button action") + App.loc.emptyString
            anchors.left: parent.left
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
        anchors.left: parent.left

        SettingsSubgroupHeader{
            text: qsTr("File exists reaction") + App.loc.emptyString
            anchors.left: parent.left
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

        anchors.left: parent.left

        SettingsSubgroupHeader{
            anchors.left: parent.left
            text: qsTr("Go back to default settings") + App.loc.emptyString
        }

        BaseButton {
            text: qsTr("Reset") + App.loc.emptyString
            enabled: App.settings.hasNonDefaultValues || uiSettingsTools.hasNonDefaultValues
            onClicked: okToResetMsg.open()
            blueBtn: true
            anchors.left: parent.left
            anchors.leftMargin: 20*appWindow.zoom
            AppMessageDialog
            {
                id: okToResetMsg
                title: qsTr("Default settings") + App.loc.emptyString
                text: qsTr("Restore default settings?") + App.loc.emptyString
                buttons: AppMessageDialog.Ok | AppMessageDialog.Cancel
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
