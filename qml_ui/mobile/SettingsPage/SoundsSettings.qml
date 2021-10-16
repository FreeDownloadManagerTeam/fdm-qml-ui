import QtQuick 2.10
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import "../../qt5compat"
import "../BaseElements"
import org.freedownloadmanager.fdm 1.0
import org.freedownloadmanager.fdm.appsettings 1.0
import org.freedownloadmanager.fdm.appnotificationevent 1.0

Page {
    id: root

    header: PageHeaderWithBackArrow {
        pageTitle: qsTr("Sounds settings") + App.loc.emptyString
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

                SwitchSetting {
                    id: switchSetting1
                    description: qsTr("Use sounds") + App.loc.emptyString
                    switchChecked: App.settings.toBool(App.settings.app.value(AppSettings.EnableSoundNotifications))
                    onClicked: {
                        switchChecked = !switchChecked;
                        App.settings.app.setValue(
                                    AppSettings.EnableSoundNotifications,
                                    App.settings.fromBool(switchChecked));
                    }
                }

                Rectangle {
                    width: parent.width
                    height: 200
                    color: "transparent"

                    ListView {
                        id: soundsList
                        focus: true
                        enabled: switchSetting1.switchChecked
                        anchors.fill: parent
                        anchors.leftMargin: 20
                        anchors.rightMargin: 20

                        property int currentSetting: -1

                        model: []

                        delegate: Rectangle {
                            property int rowHeigth: 50
                            width: parent.width
                            height: rowHeigth
                            color: "transparent"

                            RowLayout {
                                anchors.verticalCenter: parent.verticalCenter

                                width: parent.width
                                spacing: 15
                                BaseLabel {
                                    text: modelData.text
                                    font.pixelSize: 15
                                    wrapMode: Text.WordWrap
                                    horizontalAlignment: Text.AlignLeft
                                    //anchors.verticalCenter: parent.verticalCenter
                                    color: appWindow.theme.foreground
                                    Layout.fillWidth: true
                                    opacity: soundsList.enabled ? 1 : 0.5
                                }

                                ToolbarButton {
                                    icon.source: Qt.resolvedUrl("../../images/mobile/music_note.svg")
                                    icon.color: appWindow.theme.foreground

                                    enabled: modelData.soundFile
                                    onClicked: App.soundNotifMgr.playSound(modelData.setting)
                                }

                                ToolbarButton {
                                    icon.source: Qt.resolvedUrl("../../images/mobile/music_off.svg")
                                    icon.color: appWindow.theme.foreground

                                    enabled: modelData.soundFile
                                    onClicked: {
                                        soundsList.currentSetting = modelData.setting;
                                        App.soundNotifMgr.setSoundFile(soundsList.currentSetting, '');
                                        soundsList.reloadModel();
                                    }
                                }

                                ToolbarButton {
                                    icon.source: Qt.resolvedUrl("../../images/mobile/queue_music.svg")
                                    icon.color: appWindow.theme.foreground

                                    onClicked: {
                                        soundsList.currentSetting = modelData.setting;
                                        stackView.waPush(filePicker.filePickerPageComponent, {initiator: "soundsSettings", downloadId: -1, onlyFolders: false});
                                    }
                                }
                            }
                        }

                        Component.onCompleted: soundsList.reloadModel()

                        function reloadModel() {
                            soundsList.model = [{ text: qsTr("Downloads added"), setting: AppNotificationEvent.DownloadsAdded, soundFile: App.soundNotifMgr.soundFile(AppNotificationEvent.DownloadsAdded) },
                                              { text: qsTr("Downloads completed"), setting: AppNotificationEvent.DownloadsCompleted, soundFile: App.soundNotifMgr.soundFile(AppNotificationEvent.DownloadsCompleted) },
                                              { text: qsTr("Downloads failed"), setting: AppNotificationEvent.DownloadsFailed, soundFile: App.soundNotifMgr.soundFile(AppNotificationEvent.DownloadsFailed) },
                                              { text: qsTr("No active downloads"), setting: AppNotificationEvent.NoActiveDownloads, soundFile: App.soundNotifMgr.soundFile(AppNotificationEvent.NoActiveDownloads) }];
                        }
                    }
                }

            }

        }
    }

    Connections {
        target: filePicker
        onFileSelected: {
            onFileSelected: {
                App.soundNotifMgr.setSoundFile(soundsList.currentSetting, App.tools.url(fileName).toLocalFile());
                soundsList.reloadModel()
            }
        }
    }

    Connections {
        target: App.loc
        onCurrentTranslationChanged: soundsList.reloadModel()
    }
}



