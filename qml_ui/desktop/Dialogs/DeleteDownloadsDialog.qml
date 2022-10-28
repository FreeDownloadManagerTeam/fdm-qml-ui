import QtQuick 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.11
import org.freedownloadmanager.fdm 1.0
import Qt.labs.settings 1.0
import "../BaseElements"
import "../../common/Tools"

BaseDialog {
    id: root

    property var downloadIds: []
    property string dialogType: uiSettingsTools.settings.deleteButtonAction == 0 ? "Always ask" : uiSettingsTools.settings.deleteButtonAction == 1 ? "Delete files" : "unknown"

    width: 542*appWindow.zoom

    contentItem: BaseDialogItem {
        titleText: qsTr("Delete selected downloads") + App.loc.emptyString
        focus: true
        Keys.onEscapePressed: root.close()
        onCloseClick: root.close()

        ColumnLayout {
            Layout.fillWidth: true
            Layout.leftMargin: 10*appWindow.zoom
            Layout.rightMargin: 10*appWindow.zoom
            spacing: 3*appWindow.zoom

            ListView {
                clip: true
                Layout.fillWidth: true
                Layout.preferredHeight: Math.min(contentHeight, 150*appWindow.zoom)
                ScrollBar.vertical: ScrollBar {
                    active: parent.contentHeight > 150*appWindow.zoom
                }
                model: root.downloadIds
                delegate: Rectangle {
                    width: parent.width
                    height: lbl.height
                    color: 'transparent'

                    BaseLabel {
                        id: lbl
                        visible: downloadsItemTools.tplPathAndTitle.length > 0
                        width: parent.width
                        elide: Text.ElideMiddle
                        DownloadsItemTools {
                            id: downloadsItemTools
                            itemId: root.downloadIds[index]
                        }
                        text: App.toNativeSeparators(downloadsItemTools.hasChildDownloads ? downloadsItemTools.destinationPath : downloadsItemTools.tplPathAndTitle)
                    }
                }
            }

            ColumnLayout {
                visible: root.dialogType === "Always ask"
                Layout.topMargin: 10*appWindow.zoom
                Layout.bottomMargin: 10*appWindow.zoom
                Layout.fillWidth: true
                spacing: 15*appWindow.zoom

                BaseCheckBox {
                    id: rememberChoiceCbx
                    Layout.leftMargin: -6*appWindow.zoom
                    text: qsTr("Remember my choice") + App.loc.emptyString
                    checked: false
                }

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 5*appWindow.zoom

                    CustomButton {
                        id: btn1
                        Layout.alignment: Qt.AlignLeft
                        text: qsTr("Delete files") + App.loc.emptyString
                        blueBtn: true
                        alternateBtnPressed: cnclBtn.isPressed
                        onClicked: root.deleteFilesClick()
                    }

                    CustomButton {
                        Layout.alignment: Qt.AlignLeft
                        text: qsTr("Remove from list") + App.loc.emptyString
                        blueBtn: true
                        alternateBtnPressed: cnclBtn.isPressed
                        onClicked: root.removeFromList()
                    }
                    Item {
                        Layout.fillWidth: true
                    }
                    CustomButton {
                        id: cnclBtn
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("Cancel") + App.loc.emptyString
                        onClicked: root.close()
                    }
                }
            }

            RowLayout {
                visible: root.dialogType === "Delete files"
                Layout.topMargin: 10*appWindow.zoom
                Layout.bottomMargin: 10*appWindow.zoom
                Layout.alignment: Qt.AlignRight

                spacing: 5*appWindow.zoom

                CustomButton {
                    text: qsTr("OK")
                    blueBtn: true
                    alternateBtnPressed: cnclBtn1.isPressed
                    onClicked: root.deleteFilesClick()
                }

                CustomButton {
                    id: cnclBtn1
                    text: qsTr("Cancel")
                    onClicked: root.close()
                }
            }
        }
    }

    onOpened: {
        forceActiveFocus();
    }

    onClosed: {
        downloadIds = [];
    }

    function deleteFilesClick()
    {
        if (rememberChoiceCbx.checked) {
            uiSettingsTools.settings.deleteButtonAction = 1;
        }
        selectedDownloadsTools.removeFromDisk(downloadIds);
        root.close();
    }

    function removeFromList()
    {
        if (rememberChoiceCbx.checked) {
            uiSettingsTools.settings.deleteButtonAction = 2;
        }
        selectedDownloadsTools.removeFromList(downloadIds);
        root.close();
    }

    function removeAction(ids)
    {
        dialogType = uiSettingsTools.settings.deleteButtonAction == 0 ? "Always ask" : uiSettingsTools.settings.deleteButtonAction == 1 ? "Delete files" : "unknown"
        if (uiSettingsTools.settings.deleteButtonAction === 2) { //2: Remove only from download list
            selectedDownloadsTools.removeFromList(ids)
        } else {
            root.downloadIds = ids;
            root.open();
        }
    }
}
