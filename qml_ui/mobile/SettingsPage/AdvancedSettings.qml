import QtQuick 2.11
import QtQuick.Controls 2.3
import org.freedownloadmanager.fdm 1.0
import org.freedownloadmanager.fdm.appsettings 1.0
import org.freedownloadmanager.fdm.appfeatures 1.0
import org.freedownloadmanager.fdm.dmcoresettings 1.0
import "."
import "../BaseElements/"

Page {
    id: root

//    property bool smallScreen: width < 400

    header: PageHeaderWithBackArrow {
        pageTitle: qsTr("Advanced settings") + App.loc.emptyString
        onPopPage: root.StackView.view.pop()
    }

    Rectangle {
        id: settingsWraper
        color: "transparent"
        anchors.fill: parent

        Flickable
        {
            anchors.fill: parent
            flickableDirection: Flickable.VerticalFlick
            ScrollIndicator.vertical: ScrollIndicator { }
            boundsBehavior: Flickable.StopAtBounds

            contentHeight: contentColumn.height

            clip: true

            Column {
                id: contentColumn
                anchors.left: parent.left
                anchors.right: parent.right
                topPadding: 7

//-- contentColumn content - BEGIN -------------------------------------------------------------------
                Label {
                    anchors.left: parent.left
                    text: qsTr("Choose theme") + App.loc.emptyString
                    font.pixelSize: 16
                    leftPadding: qtbug.leftPadding(20, 0)
                    rightPadding: qtbug.rightPadding(20, 0)
                    bottomPadding: 10
                }

                ThemeComboBox {
                    anchors.left: parent.left
                    anchors.leftMargin: 20
                    comboMinimumWidth: 200
                }

                Label {
                    anchors.left: parent.left
                    text: qsTr("A light theme will be used, if the system theme is unknown.") + App.loc.emptyString
                    leftPadding: qtbug.leftPadding(20, 20)
                    rightPadding: qtbug.rightPadding(20, 20)
                    bottomPadding: 10
                    topPadding: 10
                    font.pixelSize: 14
                    width: parent.width
                    wrapMode: Label.WordWrap
                    visible: uiSettingsTools.settings.theme === 'system'
                }

                SettingsSeparator {}

                SwitchSetting {
                    id: switchSetting1
                    description: qsTr("Launch at startup (minimized)") + App.loc.emptyString
                    visible: App.features.hasFeature(AppFeatures.Autorun)
                    switchChecked: App.autorunEnabled()
                    onClicked: {
                        switchChecked = !switchChecked;
                        App.enableAutorun(switchChecked);
                    }
                }

                SettingsSeparator{
                    visible: switchSetting1.visible
                }

                SwitchSetting {
                    id: switchSetting3
                    description: qsTr("Do not share files when running on battery") + App.loc.emptyString
                    visible: App.features.hasFeature(AppFeatures.Battery) && appWindow.hasDownloadMgr
                    switchChecked: App.settings.toBool(App.settings.dmcore.value(DmCoreSettings.DisablePostFinishedTasksOnBattery))
                    onClicked: {
                        switchChecked = !switchChecked;
                        App.settings.dmcore.setValue(
                                    DmCoreSettings.DisablePostFinishedTasksOnBattery,
                                    App.settings.fromBool(switchChecked));
                    }
                }

                SettingsSeparator{
                    visible: switchSetting3.visible
                }

                SwitchSetting {
                    id: switchSetting4
                    description: qsTr("Do not allow downloads if battery level drops below") + App.loc.emptyString
                    visible: App.features.hasFeature(AppFeatures.Battery) && appWindow.hasDownloadMgr
                    switchChecked: App.settings.dmcore.value(DmCoreSettings.BatteryMinimumPowerLevelToRunDownloads) > 0
                    onClicked: {
                        switchChecked = !switchChecked;
                        if (switchChecked) {
                            batteryCombo.saveBatteryMinimumPowerLevelToRunDownloads(batteryCombo.currentText);
                        } else {
                            batteryCombo.saveBatteryMinimumPowerLevelToRunDownloads(0);
                        }
                    }
                }

                BatteryComboBox {
                    id: batteryCombo
                    visible: App.features.hasFeature(AppFeatures.Battery) && appWindow.hasDownloadMgr
                    enabled: switchSetting4.switchChecked
                    anchors.left: parent.left
                    anchors.leftMargin: 20
                    comboMinimumWidth: 100
                }

                Item {implicitHeight: 10; implicitWidth: 1}

                SettingsSeparator{
                    visible: switchSetting4.visible
                }

                SwitchSetting {
                    id: switchSetting2
                    visible: appWindow.hasDownloadMgr
                    description: qsTr("Backup the list of downloads every") + App.loc.emptyString + " <b>" + backupSlider.currentText + "</b>"
                    switchChecked: App.settings.dbBackupMinInterval() != -1
                    onClicked: {
                        switchChecked = !switchChecked;
                        if (switchChecked) {
                            App.settings.setDbBackupMinInterval(backupSlider.model[backupSlider.value].value);
                        } else {
                            App.settings.setDbBackupMinInterval(-1);
                        }
                    }
                }

                BackupSlider {
                    id: backupSlider
                    visible: switchSetting2.visible
                    enabled: switchSetting2.switchChecked
                    anchors.left: parent.left
                }

                SettingsSeparator{
                    visible: switchSetting2.visible
                }

                Label {
                    id: fileExistsReactionLabel
                    visible: appWindow.hasDownloadMgr
                    text: qsTr("File exists reaction") + App.loc.emptyString
                    font.pixelSize: 16
                    leftPadding: qtbug.leftPadding(20, 0)
                    rightPadding: qtbug.rightPadding(20, 0)
                    bottomPadding: 10
                    topPadding: 15
                    anchors.left: parent.left
                    horizontalAlignment: Text.AlignLeft
                }

                ExistingFileReactionCombobox {
                    visible: fileExistsReactionLabel.visible
                    anchors.left: parent.left
                    anchors.leftMargin: 20
                }

                Item {implicitHeight: 10; implicitWidth: 1}

                SettingsSeparator{
                    visible: fileExistsReactionLabel.visible
                }

//-- contentColumn content - END ---------------------------------------------------------------------
            }

        }
    }


}



