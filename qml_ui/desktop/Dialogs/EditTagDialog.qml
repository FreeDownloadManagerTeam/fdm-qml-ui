import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import "../../qt5compat"
import org.freedownloadmanager.fdm 1.0
import "../BaseElements"
import "../SettingsPage"
import "../../common"

import Qt.labs.platform 1.0 as QtLabs

BaseDialog {
    id: root

    width: 480*appWindow.zoom

    contentItem: BaseDialogItem {
        titleText: qsTr("Edit tag") + App.loc.emptyString
        Keys.onReturnPressed: save()
        Keys.onEscapePressed: root.close()
        onCloseClick: root.close()

        Column {
            spacing: 5*appWindow.zoom
            Layout.fillWidth: true
            Layout.leftMargin: 10*appWindow.zoom
            Layout.rightMargin: 10*appWindow.zoom
            Layout.bottomMargin: 10*appWindow.zoom


            BaseLabel {
                anchors.left: parent.left
                text: qsTr("Tag") + App.loc.emptyString
            }

            Row {
                anchors.left: parent.left
                spacing: 10*appWindow.zoom

                BaseTextField {
                    id: textInput
                    width: 200*appWindow.zoom
                    focus: true
                    text: tagsTools.editedTagName
                    onTextEdited: {tagsTools.editedTagName = text }
                    onAccepted: save()
                    onVisibleChanged: {
                        text = tagsTools ? tagsTools.editedTagName : '';
                    }
                    Keys.onEscapePressed: { root.close(); tagsTools.endTagEditing(); }
                    maximumLength: 20
                    enable_QTBUG_110471_workaround_2: true
                }

                //color
                Rectangle {
                    id: marker
                    anchors.verticalCenter: parent.verticalCenter
                    width: 11*appWindow.zoom
                    height: 12*appWindow.zoom
                    color: tagsTools.editedTagColor
                    clip: true

                    Component.onCompleted: {marker.color = tagsTools.editedTagColor}

                    WaSvgImage {
                        visible: colorMouseArea.containsMouse
                        source: appWindow.theme.elementsIcons
                        zoom: appWindow.zoom
                        x: 1*appWindow.zoom
                        y: -447*appWindow.zoom
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
                        y: 14*appWindow.zoom
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

            BaseLabel {
                anchors.left: parent.left
                text: qsTr('Extensions (e.g. "avi mp3")') + App.loc.emptyString
                topPadding: 5*appWindow.zoom

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
                anchors.left: parent.left
                width: 300*appWindow.zoom
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
                enable_QTBUG_110471_workaround_2: true
            }

            BaseLabel {
                anchors.left: parent.left
                text: qsTr("Default download folder") + App.loc.emptyString
                topPadding: 5*appWindow.zoom
            }

            Row {
                anchors.left: parent.left
                spacing: 10*appWindow.zoom

                FolderCombobox {
                    id: downloadFolder
                    implicitWidth: 300*appWindow.zoom
                    onEditTextChanged: {
                        tagsTools.editedTagDownloadFolder = editText;
                    }
                    onAccepted: save()
                }

                PickFileButton {
                    id: folderBtn
                    visible: !App.rc.client.active                  
                    height: downloadFolder.height
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
                    implicitHeight: 30*appWindow.zoom
                    onClicked: macrosMenu.open()

                    MacrosMenu {
                        id: macrosMenu
                        onMacroSelected: { downloadFolder.editText += macro; }
                    }
                }
            }

            Row {
                spacing: 5*appWindow.zoom
                anchors.right: parent.right
                height: 50*appWindow.zoom

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
