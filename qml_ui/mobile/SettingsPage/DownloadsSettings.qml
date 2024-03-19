import QtQuick 2.11
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import "../../qt5compat"
import org.freedownloadmanager.fdm 1.0
import org.freedownloadmanager.fdm.appsettings 1.0
import org.freedownloadmanager.fdm.appfeatures 1.0
import org.freedownloadmanager.fdm.dmcoresettings 1.0
import "."
import "../BaseElements/"

Page {
    id: root

    property var storages: []

    header: PageHeaderWithBackArrow {
        pageTitle: qsTr("Downloads settings") + App.loc.emptyString
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

            Column {
                id: contentColumn
                anchors.left: parent.left
                anchors.right: parent.right
                topPadding: 7

//-- contentColumn content - BEGIN -------------------------------------------------------------------
                SwitchSetting {
                    description: qsTr("Start downloading without confirmation") + App.loc.emptyString
                    switchChecked: App.settings.toBool(App.settings.app.value(AppSettings.SilentModeForNewDownloads))
                    onClicked: {
                        switchChecked = !switchChecked;
                        App.settings.app.setValue(
                                    AppSettings.SilentModeForNewDownloads,
                                    App.settings.fromBool(switchChecked));
                    }
                }

                SettingsSeparator{}

                SwitchSetting {
                    description: qsTr("Automatically remove deleted files from download list") + App.loc.emptyString
                    switchChecked: downloadsWithMissingFilesTools.autoRemoveDownloads
                    onClicked: {
                        switchChecked = !switchChecked;
                        downloadsWithMissingFilesTools.autoRemoveDownloads = switchChecked;
                    }
                }

                SettingsSeparator{}

                SwitchSetting {
                    id: removeFinished
                    description: qsTr("Automatically remove completed downloads from download list") + App.loc.emptyString
                    switchChecked: App.settings.toBool(App.settings.dmcore.value(DmCoreSettings.AutoRemoveFinishedDownloads))
                    onClicked: {
                        switchChecked = !switchChecked;
                        App.settings.dmcore.setValue(
                                    DmCoreSettings.AutoRemoveFinishedDownloads,
                                    App.settings.fromBool(switchChecked));
                    }
                }

                Row {
                    visible: removeFinished.switchChecked
                    leftPadding: qtbug.leftPadding(40, 0)
                    rightPadding: qtbug.rightPadding(40, 0)
                    spacing: 3

                    SettingsRadioButton {
                        id: removeFinishedImmediately
                        text: qsTr("Immediately") + App.loc.emptyString
                        checked: !parseInt(App.settings.dmcore.value(DmCoreSettings.AutoRemoveFinishedDownloads_KeepDays))
                        anchors.verticalCenter: parent.verticalCenter
                        onClicked: {
                            App.settings.dmcore.setValue(
                                        DmCoreSettings.AutoRemoveFinishedDownloads_KeepDays,
                                        "0");
                        }
                    }

                    Item {
                        implicitWidth: 15
                        implicitHeight: 1
                    }

                    SettingsRadioButton {
                        id: removeFinishedIn
                        checked: !removeFinishedImmediately.checked
                        //: Automatically remove finished downloads In N days
                        text: qsTr("In") + App.loc.emptyString
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
                        implicitWidth: 40
                        inputMethodHints: Qt.ImhDigitsOnly
                        validator: QtRegExpValidator { regExp: /[1-9]\d*/ }
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

                    BaseLabel {
                        enabled: removeFinishedIn.checked
                        //: Automatically remove finished downloads In N days
                        text: qsTr("days") + App.loc.emptyString
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }

                SettingsSeparator{}

                SwitchSetting {
                    description: qsTr("Automatically retry failed downloads") + App.loc.emptyString
                    switchChecked: App.settings.toBool(App.settings.dmcore.value(DmCoreSettings.AutoRetryFailedDownloads))
                    onClicked: {
                        switchChecked = !switchChecked;
                        App.settings.dmcore.setValue(
                                    DmCoreSettings.AutoRetryFailedDownloads,
                                    App.settings.fromBool(switchChecked));
                    }
                }

                SettingsSeparator{}

                SwitchSetting {
                    description: qsTr("Do not download web pages") + App.loc.emptyString
                    switchChecked: App.settings.toBool(App.settings.dmcore.value(DmCoreSettings.DetectUnwantedDownloadErrors))
                    onClicked: {
                        switchChecked = !switchChecked;
                        App.settings.dmcore.setValue(
                                    DmCoreSettings.DetectUnwantedDownloadErrors,
                                    App.settings.fromBool(switchChecked));
                    }
                }

                SettingsSeparator{}

                SwitchSetting {
                    description: qsTr("Use server time for file creation") + App.loc.emptyString
                    switchChecked: App.settings.toBool(App.settings.dmcore.value(DmCoreSettings.TakeLastModifiedDateFromServer))
                    onClicked: {
                        switchChecked = !switchChecked;
                        App.settings.dmcore.setValue(
                                    DmCoreSettings.TakeLastModifiedDateFromServer,
                                    App.settings.fromBool(switchChecked));
                    }
                }

                SettingsSeparator{}

                SettingsGroupHeader {
                    name: qsTr("Default download folder") + App.loc.emptyString
                    width: parent.width
                }

                SettingsRadioButton
                {
                    id: autoFolderRadioBtn
                    text: qsTr("Choose default download folder automatically") + App.loc.emptyString
                    checked: !fixedFolderRadioBtn.checked
                    leftPadding: qtbug.leftPadding(20, 0)
                    rightPadding: qtbug.rightPadding(20, 0)
                    font.pixelSize: 16
                    width: parent.width
                    onCheckedChanged: {
                        if (checked)
                            App.settings.dmcore.setValue(DmCoreSettings.FixedDownloadPath, "");
                    }
                }

                SwitchSetting {
                    id: switchSetting1
                    description: qsTr("Suggest folders based on file type") + App.loc.emptyString
                    enabled: autoFolderRadioBtn.checked
                    switchChecked: App.settings.toBool(App.settings.dmcore.value(DmCoreSettings.DownloadPathDependsOnFileType))
                    anchors.leftMargin: 25
                    onClicked: {
                        switchChecked = !switchChecked;
                        App.settings.dmcore.setValue(
                                    DmCoreSettings.DownloadPathDependsOnFileType,
                                    App.settings.fromBool(switchChecked));
                    }
                }

                SettingsSeparator{}

                SwitchSetting {
                    id: switchSetting2
                    description: qsTr("Suggest folders based on download URL") + App.loc.emptyString
                    enabled: autoFolderRadioBtn.checked
                    switchChecked: App.settings.toBool(App.settings.dmcore.value(DmCoreSettings.DownloadPathDependsOnSourceUrl))
                    anchors.leftMargin: 25
                    onClicked: {
                        switchChecked = !switchChecked;
                        App.settings.dmcore.setValue(
                                    DmCoreSettings.DownloadPathDependsOnSourceUrl,
                                    App.settings.fromBool(switchChecked));
                    }
                }

                SettingsSeparator{}

                SettingsRadioButton
                {
                    id: fixedFolderRadioBtn
                    text: qsTr("Fixed default download folder") + App.loc.emptyString
                    checked: App.settings.dmcore.value(DmCoreSettings.FixedDownloadPath).length > 0
                    onCheckedChanged: {
                        if (checked)
                            fixedFolderCombo.apply();
                    }
                    leftPadding: qtbug.leftPadding(20, 0)
                    rightPadding: qtbug.rightPadding(20, 0)
                    topPadding: 20
                    font.pixelSize: 16
                    width: parent.width
                }

                FixedDownloadFolderCombobox {
                    id: fixedFolderCombo
                    enabled: fixedFolderRadioBtn.checked
                }

                Item {implicitHeight: 20; implicitWidth: 1}

//-- contentColumn content - END ---------------------------------------------------------------------
            }
        }
    }
}
