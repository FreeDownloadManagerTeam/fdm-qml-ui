import QtQuick 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.11
import "../../qt5compat"
import org.freedownloadmanager.fdm 1.0
import org.freedownloadmanager.fdm.abstractdownloadsui 1.0
import "../BaseElements"
import "../../common/Tools"

import Qt.labs.platform 1.0 as QtLabs

BaseDialog {
    id: root

    property string filePath
    property string errorMessage

    property var selectedDownloads: []

    width: 542

    contentItem: BaseDialogItem {
        titleText: (selectedDownloads.length > 0 ? qsTr("Export selected downloads") : qsTr("Export all downloads")) + App.loc.emptyString
        focus: true
        Keys.onEscapePressed: root.close()
        Keys.onReturnPressed: root.close()
        onCloseClick: root.close()

        ColumnLayout {
            Layout.fillWidth: true
            Layout.leftMargin: 10
            Layout.rightMargin: 10
            spacing: 3

            BaseLabel {
                text: qsTr("Save to") + App.loc.emptyString
            }

            RowLayout {
                height: folderBtn.height + 1
                width: parent.width

                BaseTextField {
                    id: path
                    Layout.fillWidth: true
                    Layout.preferredHeight: height
                    onAccepted: doOK();
                }

                CustomButton {
                    id: folderBtn
                    implicitWidth: 38
                    implicitHeight: 30
                    Layout.alignment: Qt.AlignRight
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

                    QtLabs.FileDialog {
                        id: browseDlg
                        fileMode: QtLabs.FileDialog.SaveFile
                        acceptLabel: qsTr("Open") + App.loc.emptyString
                        rejectLabel: qsTr("Cancel") + App.loc.emptyString
                        nameFilters: [ typeCombo.filter, qsTr("All files (%1)").arg("*") + App.loc.emptyString ]
                        defaultSuffix: typeCombo.extension
                        onAccepted: {
                            path.text = App.toNativeSeparators(App.tools.url(file).toLocalFile());
                        }
                    }
                }
            }

            ExportDownloadsTypeCombobox {
                id: typeCombo
                Layout.preferredWidth: 200
                Layout.preferredHeight: 30
                Layout.topMargin: 10
                Layout.bottomMargin: 10
                onExtensionChanged: fixPath()
            }

            BaseCheckBox {
                id: finishedOnly
                text: qsTr("Export only completed downloads") + App.loc.emptyString
                checkBoxStyle: "gray"
                Layout.topMargin: 10
                Layout.bottomMargin: 10
            }

            RowLayout {
                Layout.topMargin: 10
                Layout.bottomMargin: 10
                Layout.alignment: Qt.AlignRight

                CustomButton {
                    id: cnclBtn
                    Layout.preferredHeight: height
                    Layout.alignment: Qt.AlignRight
                    text: qsTr("Cancel") + App.loc.emptyString
                    onClicked: root.close()
                }

                CustomButton {
                    id: okbtn
                    Layout.preferredHeight: height
                    Layout.alignment: Qt.AlignRight
                    text: qsTr("Export") + App.loc.emptyString
                    blueBtn: true
                    alternateBtnPressed: cnclBtn.isPressed
                    onClicked: doOK();
                }
            }
        }
    }

    onOpened: {
        forceActiveFocus();
    }

    onClosed: {
        errorMessage = "";
        filePath = "";
    }

    function exportAll() {
        selectedDownloads = [];
        setDefaultPath();
        open();
    }

    function exportSelected() {
        selectedDownloads = selectedDownloadsTools.getCurrentDownloadIds();
        setDefaultPath();
        open();
    }

    function setDefaultPath() {
        browseDlg.currentFile = "file://" + uiSettingsTools.settings.exportImportPath + "/" + App.shortDisplayName.toLowerCase() + '_downloads';
    }

    function fixPath() {
        path.text = path.text.replace(/\/([^\/\.]+)(\.\w*)?$/, '/$1.' + typeCombo.extension);
        path.text = path.text.replace(/\/$/, '/' + App.shortDisplayName.toLowerCase() + '_downloads' + '.' + typeCombo.extension);
        path.text = App.toNativeSeparators(path.text);
    }

    function doOK() {
        fixPath();
        uiSettingsTools.settings.exportImportPath = App.fromNativeSeparators(path.text.replace(/\/([^\/]+)?$/, ''));
        if (typeCombo.currentIndex === 0) {
            App.exportImport.exportDownloads(selectedDownloads, finishedOnly.checked, App.fromNativeSeparators(path.text));
        } else if (typeCombo.currentIndex === 1) {
            App.exportImport.exportDownloadsAsListOfUrls(selectedDownloads, finishedOnly.checked, App.fromNativeSeparators(path.text));
        } else if (typeCombo.currentIndex === 2) {
            App.exportImport.exportDownloadsToCsv(selectedDownloads,
                AbstractDownloadsUi.Url | AbstractDownloadsUi.File | AbstractDownloadsUi.Size | AbstractDownloadsUi.Date,
                finishedOnly.checked, App.fromNativeSeparators(path.text));
        }
        root.close();
    }
}
