import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
import org.freedownloadmanager.fdm 1.0
import "../BaseElements"
import "../SettingsPage"

import Qt.labs.platform 1.0 as QtLabs

BaseDialog {
    id: root

    width: 480

    contentItem: BaseDialogItem {
        titleText: qsTr("Edit tag") + App.loc.emptyString
        Keys.onReturnPressed: save()
        Keys.onEscapePressed: root.close()
        onCloseClick: root.close()

        Column {
            spacing: 5
            Layout.fillWidth: true
            Layout.leftMargin: 10
            Layout.rightMargin: 10
            Layout.bottomMargin: 10


            Label {
                text: qsTr("Tag") + App.loc.emptyString
            }

            Row {
                spacing: 10

                BaseTextField {
                    id: textInput
                    width: 200
                    focus: true
                    onTextEdited: {tagsTools.editedTagName = text }
                    onAccepted: save()
                    onVisibleChanged: {
                        text = tagsTools ? tagsTools.editedTagName : '';
                    }
                    Keys.onEscapePressed: { root.close(); tagsTools.endTagEditing(); }
                    maximumLength: 20
                    Component.onCompleted: {
                        text = tagsTools.editedTagName;
                    }
                }

                //color
                Rectangle {
                    id: marker
                    anchors.verticalCenter: parent.verticalCenter
                    width: 11
                    height: 12
                    color: tagsTools.editedTagColor
                    clip: true

                    Component.onCompleted: {marker.color = tagsTools.editedTagColor}

                    Image {
                        visible: colorMouseArea.containsMouse
                        source: appWindow.theme.elementsIcons
                        sourceSize.width: 93
                        sourceSize.height: 456
                        x: 1
                        y: -447
                        layer {
                            effect: ColorOverlay {
                                color: "#fff"
                            }
                            enabled: true
                        }
                    }

                    MouseArea {
                        id: colorMouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: tagPalette.toggle()
                    }

                    TagColorDialog {
                        id: tagPalette
                        visible: false
                        tagColor: tagsTools.editedTagColor
                        y: 14
                        onOpened: textInput.forceActiveFocus();
                        onTagColorChanged: {
                            tagsTools.editedTagColor = tagColor;
                            marker.color = tagsTools.editedTagColor;
                        }

                        function toggle() {
                            if (this.opened) {
                                this.close()
                            } else {
                                this.open()
                            }
                        }
                    }
                }


                Connections {
                    target: tagsTools
                    onEditedTagColorChanged: {marker.color = tagsTools.editedTagColor}
                }
            }

            Label {
                text: qsTr('Extensions (e.g. "avi mp3")') + App.loc.emptyString
                topPadding: 5

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    hoverEnabled: true

                    BaseToolTip {
                        text: qsTr('Extensions that are automatically assigned with this tag for new downloads') + App.loc.emptyString
                        visible: parent.containsMouse
                    }
                }
            }

            BaseTextField {
                width: 300
                onVisibleChanged: {
                    if (tagsTools && tagsTools.editedTagExtensions) {
                        text = tagsTools.editedTagExtensions.join(" ");
                    }
                }
                onTextEdited:{
                    var m = text.match(/[^\s]+/g);
                    tagsTools.editedTagExtensions = m && m.length > 0 ? m : [];
                }
                onAccepted: save()
            }

            Label {
                text: qsTr("Default download folder") + App.loc.emptyString
                topPadding: 5
            }

            Row {
                spacing: 10

                FolderCombobox {
                    id: downloadFolder
                    implicitWidth: 300
                    implicitHeight: 30
                    onEditTextChanged: {
                        tagsTools.editedTagDownloadFolder = editText;
                    }
                    onAccepted: save()
                }

                CustomButton {
                    id: folderBtn
                    implicitWidth: 38
                    implicitHeight: 30
                    Layout.preferredHeight: height
                    Image {
                        source: Qt.resolvedUrl("../../images/desktop/pick_file.svg")
                        sourceSize.width: 37
                        sourceSize.height: 30
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
                        folder: App.tools.urlFromLocalFile(downloadFolder.editText).url
                        acceptLabel: qsTr("Open") + App.loc.emptyString
                        rejectLabel: qsTr("Cancel") + App.loc.emptyString
                        onAccepted: { downloadFolder.editText = App.tools.url(folder).toLocalFile() }
                    }
                }

                CustomButton {
                    text: qsTr("Macros") + App.loc.emptyString
                    implicitHeight: 30
                    onClicked: macrosMenu.open()

                    MacrosMenu {
                        id: macrosMenu
                        onMacroSelected: { downloadFolder.editText += macro; }
                    }
                }
            }

            Row {
                spacing: 5
                anchors.right: parent.right
                height: 50

                CustomButton {
                    id: cnclBtn
                    text: qsTr("Cancel") + App.loc.emptyString
                    anchors.bottom: parent.bottom
                    onClicked: {
                        root.close()
                    }
                }

                CustomButton {
                    text: qsTr("OK") + App.loc.emptyString
                    anchors.bottom: parent.bottom
                    blueBtn: true
                    alternateBtnPressed: cnclBtn.isPressed
                    enabled: textInput.text.length > 0
                    onClicked: save()
                }
            }
        }
    }

    onClosed: appWindow.appWindowStateChanged()
    onOpened: {
        downloadFolderInitialization();
        forceActiveFocus();
    }

    function save() {
        tagsTools.changeTagData();
        root.close()
    }

    function downloadFolderInitialization() {
        var folderList = App.recentFolders;
        var currentFolder = tagsTools.editedTagDownloadFolder;
        downloadFolder.model.clear();

        if (!folderList.length) {
            folderList = [];
            folderList.push(currentFolder);
        }

        for (var i = 0; i < folderList.length; i++) {
            downloadFolder.model.insert(i, {'folder': folderList[i]});
        }

        downloadFolder.editText = currentFolder;
        downloadFolder.setPopupWidth();
    }
}
