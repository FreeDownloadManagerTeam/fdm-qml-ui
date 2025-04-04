import QtQuick 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.11
import Qt.labs.platform 1.1
import "../../qt5compat"
import org.freedownloadmanager.fdm 1.0
import org.freedownloadmanager.fdm.abstractdownloadsui 1.0
import "../BaseElements"
import "../../common"
import "../../common/Tools"

import Qt.labs.platform 1.0 as QtLabs

BaseDialog {
    id: root

    property string filePath
    property string errorMessage

    property var selectedDownloads: []

    title: (selectedDownloads.length > 0 ? qsTr("Export selected downloads") : qsTr("Export all downloads")) + App.loc.emptyString
    onCloseClick: root.close()

    contentItem: BaseDialogItem {
        focus: true
        Keys.onEscapePressed: root.close()
        Keys.onReturnPressed: root.close()

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 3*appWindow.zoom

            BaseLabel {
                text: qsTr("Save to") + App.loc.emptyString
                dialogLabel: true
            }

            RowLayout {
                Layout.fillWidth: true

                BaseTextField {
                    id: path
                    Layout.fillWidth: true
                    Layout.minimumWidth: 400*appWindow.zoom
                    Layout.preferredHeight: height
                    onAccepted: doOK();
                    onTextChanged: browseDlg.currentFile = App.tools.urlFromLocalFile(text).url
                }

                PickFileButton {
                    id: folderBtn
                    Layout.alignment: Qt.AlignRight
                    Layout.fillHeight: true
                    toBrowseForFolder: false

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
                Layout.preferredWidth: 200*appWindow.zoom
                Layout.preferredHeight: 30*appWindow.zoom
                Layout.topMargin: 10*appWindow.zoom
                Layout.bottomMargin: 10*appWindow.zoom
                onExtensionChanged: fixPath()
            }

            BaseCheckBox {
                id: finishedOnly
                text: qsTr("Export only completed downloads") + App.loc.emptyString
                checkBoxStyle: "gray"
                Layout.topMargin: 10*appWindow.zoom
                Layout.bottomMargin: 10*appWindow.zoom
                xOffset: 0
            }

            RowLayout {
                Layout.topMargin: 10*appWindow.zoom
                Layout.alignment: Qt.AlignRight

                BaseButton {
                    id: cnclBtn
                    Layout.preferredHeight: height
                    Layout.alignment: Qt.AlignRight
                    text: qsTr("Cancel") + App.loc.emptyString
                    onClicked: root.close()
                }

                BaseButton {
                    id: okbtn
                    enabled: path.text
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
        if (!path.text)
            return;
        let p = App.fromNativeSeparators(path.text);
        let pp = App.tools.filePathPart(p);
        if (!pp.endsWith('/'))
            pp += '/';
        pp += App.tools.fileTitlePart(p) + "." +
                typeCombo.extension;
        path.text = App.toNativeSeparators(pp);
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
