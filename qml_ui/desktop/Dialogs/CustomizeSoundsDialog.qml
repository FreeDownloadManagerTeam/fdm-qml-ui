import QtQuick 2.10
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import "../../qt5compat"
import "../BaseElements"
import org.freedownloadmanager.fdm 1.0
import org.freedownloadmanager.fdm.appnotificationevent 1.0

BaseDialog {
    id: root

    width: 542*appWindow.zoom

    property int selectedItem: -1

    contentItem: BaseDialogItem {
        titleText: qsTr("Customize sounds") + App.loc.emptyString
        Keys.onEscapePressed: root.close()
        onCloseClick: root.close()

        ColumnLayout {
            Layout.fillWidth: true
            Layout.leftMargin: 10*appWindow.zoom
            Layout.rightMargin: 10*appWindow.zoom
            spacing: 7*appWindow.zoom

            Rectangle {
                color: appWindow.theme.background
                border.width: 1*appWindow.zoom
                border.color: appWindow.theme.border
                Layout.preferredWidth: 500*appWindow.zoom
                Layout.preferredHeight: 150*appWindow.zoom

                ListView {
                    id: soundsList
                    anchors.fill: parent
                    anchors.bottomMargin: 1*appWindow.zoom
                    anchors.topMargin: 1*appWindow.zoom
                    ScrollBar.vertical: ScrollBar{}
                    flickableDirection: Flickable.AutoFlickIfNeeded
                    boundsBehavior: Flickable.StopAtBounds
                    clip: true

                    model: []

                    header: RowLayout {
                        width: parent.width
                        spacing: 0
                        z: 2

                        TablesHeaderItem {
                            id: hostItem
                            text: qsTr("Event") + App.loc.emptyString
                            Layout.preferredWidth: 250*appWindow.zoom
                            color: appWindow.theme.background
                        }

                        TablesHeaderItem {
                            id: portItem
                            text: qsTr("Sound file") + App.loc.emptyString
                            Layout.preferredWidth: 250*appWindow.zoom
                            color: appWindow.theme.background

                            Rectangle {
                                height: parent.height
                                width: 1*appWindow.zoom
                                anchors.right: parent.right
                                color: appWindow.theme.border
                            }
                        }
                    }

                    delegate: Rectangle {
                        property int rowHeigth: 22*appWindow.zoom
                        width: parent.width
                        height: rowHeigth
                        color: "transparent"

                        RowLayout {
                            anchors.fill: parent
                            spacing: 0

                            BaseLabel {
                                text: modelData.text
                                Layout.preferredWidth: 250*appWindow.zoom
                                Layout.fillHeight: true
                                verticalAlignment: Text.AlignVCenter
                                leftPadding: 6*appWindow.zoom
                            }

                            BaseLabel {
                                id: label
                                text: modelData.soundFile.length ? modelData.soundFile : qsTr("No sound") + App.loc.emptyString
                                Layout.preferredWidth: 250*appWindow.zoom
                                Layout.fillHeight: true
                                verticalAlignment: Text.AlignVCenter
                                leftPadding: 6*appWindow.zoom
                                elide: Text.ElideMiddle

                                MouseArea {
                                    id: mouseAreaLabel
                                    propagateComposedEvents: true
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    onClicked: function (mouse) {mouse.accepted = false;}
                                    onPressed: function (mouse) {mouse.accepted = false;}

                                    BaseToolTip {
                                        text: label.text
                                        visible: label.truncated && mouseAreaLabel.containsMouse
                                        width: 250*appWindow.zoom
                                        onVisibleChanged: {
                                            if (visible) {
                                                x = mouseAreaLabel.mouseX
                                                y = mouseAreaLabel.mouseY + 20
                                            }
                                        }
                                    }
                                }
                            }
                        }

                        MouseArea {
                            z: 10
                            anchors.fill: parent
                            onClicked: {
                                soundsList.currentIndex = index;
                            }
                            onDoubleClicked: setSoundDlg.openDialog()
                        }
                    }

                    highlight: Rectangle {
                        width: soundsList.width
                        height: soundsList.delegate ? soundsList.delegate.height : 0
                        color: appWindow.theme.menuHighlight
                        y: soundsList.currentItem ? soundsList.currentItem.y : 0
                    }

                    Rectangle {
                        height: parent.height
                        width: 1*appWindow.zoom
                        anchors.left: parent.left
                        color: appWindow.theme.border
                    }
                    Rectangle {
                        height: parent.height
                        width: 1*appWindow.zoom
                        anchors.right: parent.right
                        color: appWindow.theme.border
                    }

                    Component.onCompleted: soundsList.reloadModel()

                    function reloadModel() {
                        var index = soundsList.currentIndex;
                        soundsList.model = [{ text: qsTr("Downloads added"), setting: AppNotificationEvent.DownloadsAdded, soundFile: App.soundNotifMgr.soundFile(AppNotificationEvent.DownloadsAdded) },
                                          { text: qsTr("Downloads completed"), setting: AppNotificationEvent.DownloadsCompleted, soundFile: App.soundNotifMgr.soundFile(AppNotificationEvent.DownloadsCompleted) },
                                          { text: qsTr("Downloads failed"), setting: AppNotificationEvent.DownloadsFailed, soundFile: App.soundNotifMgr.soundFile(AppNotificationEvent.DownloadsFailed) },
                                          { text: qsTr("No active downloads"), setting: AppNotificationEvent.NoActiveDownloads, soundFile: App.soundNotifMgr.soundFile(AppNotificationEvent.NoActiveDownloads) }];
                        soundsList.currentIndex = index;
                    }
                }
            }

            RowLayout {
                Layout.topMargin: 10*appWindow.zoom
                Layout.bottomMargin: 10*appWindow.zoom
                Layout.alignment: Qt.AlignRight
                Layout.fillWidth: true

                spacing: 5*appWindow.zoom

                CustomButton {
                    text: qsTr("Set sound") + App.loc.emptyString
                    enabled: soundsList.currentIndex >= 0
                    onClicked: setSoundDlg.openDialog()
                    Layout.alignment: Qt.AlignRight
                }

                CustomButton {
                    text: qsTr("Remove") + App.loc.emptyString
                    enabled: soundsList.currentIndex >= 0 && soundsList.model[soundsList.currentIndex].soundFile
                    onClicked: {
                        App.soundNotifMgr.setSoundFile(soundsList.model[soundsList.currentIndex].setting, '')
                        soundsList.reloadModel()
                    }
                    Layout.alignment: Qt.AlignRight
                }

                CustomButton {
                    text: qsTr("Test") + App.loc.emptyString
                    enabled: soundsList.currentIndex >= 0 && soundsList.model[soundsList.currentIndex].soundFile
                    onClicked: App.soundNotifMgr.playSound(soundsList.model[soundsList.currentIndex].setting)
                    Layout.alignment: Qt.AlignRight
                }

                CustomButton {
                    text: qsTr("Close") + App.loc.emptyString
                    onClicked: root.close()
                    Layout.alignment: Qt.AlignRight
                }
            }
        }
    }

    onClosed: appWindow.appWindowStateChanged()

    FileDialog {
        id: setSoundDlg
        onAccepted: {
            App.soundNotifMgr.setSoundFile(soundsList.model[soundsList.currentIndex].setting, App.tools.url(fileUrl).toLocalFile());
            soundsList.reloadModel()
        }
        function openDialog() {
            if (soundsList.model[soundsList.currentIndex].soundFile.length > 0) {
                setSoundDlg.folder = App.tools.urlFromLocalFile(soundsList.model[soundsList.currentIndex].soundFile).url;
            }
            setSoundDlg.open()
        }
    }

    Connections {
        target: App.loc
        onCurrentTranslationChanged: soundsList.reloadModel()
    }
}
