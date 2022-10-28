import QtQuick 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.11
import "../../qt5compat"
import org.freedownloadmanager.fdm 1.0
import "../BaseElements"
import "../../common"
import "../../common/Tools"

BaseStandaloneCapableDialog {
    id: root

    width: 542*appWindow.zoom

    contentItem: BaseDialogItem {
        titleText: qsTr("Add download") + App.loc.emptyString
        showCloseButton: !root.standalone
        onCloseClick: downloadTools.doReject()

        ColumnLayout {
            Layout.fillWidth: true
            Layout.leftMargin: 10*appWindow.zoom
            Layout.rightMargin: 10*appWindow.zoom
            spacing: 3*appWindow.zoom

            BaseLabel {
                text: App.cfg.cdEnterUrlText + App.loc.emptyString
            }

            RowLayout {
                Layout.fillWidth: true

                BaseTextField {
                    id: urlField
                    focus: true
                    Layout.fillWidth: true
                    text: downloadTools.urlText
                    onTextChanged: downloadTools.onUrlTextChanged(text)
                    onAccepted: downloadTools.doOK()
                    enabled: !downloadTools.buildingDownload && !downloadTools.buildingDownloadFinished
                    Keys.onEscapePressed: downloadTools.doReject()
                }

                PickFileButton {
                    id: folderBtn
                    visible: App.cfg.cdShowOpenFileBtn
                    Layout.alignment: Qt.AlignRight
                    Layout.fillHeight: true
                    onClicked: browseDlg.open()
                    FileDialog {
                        id: browseDlg
                        nameFilters: [ "Files (" + App.cfg.cdOpenFileDlgNameFilters + ')' ]
                        onAccepted: {
                            downloadTools.onUrlTextChanged(fileUrl);
                            downloadTools.doOK();
                        }
                    }
                }
            }

            ModulesCombobox {
                Layout.preferredWidth: 200*appWindow.zoom
                Layout.preferredHeight: 30*appWindow.zoom
            }

            RowLayout {
                Layout.topMargin: 10*appWindow.zoom
                Layout.bottomMargin: 10*appWindow.zoom

                BusyIndicator
                {
                    visible: downloadTools.buildingDownload
                    running: visible
                    Layout.preferredHeight: 30*appWindow.zoom
                    Layout.preferredWidth: 30*appWindow.zoom
                    Layout.alignment: Qt.AlignLeft
                }

                Rectangle {
                    color: "transparent"
                    height: okbtn.height
                    Layout.fillWidth: true

                    BaseLabel {
                        anchors.verticalCenter: parent.verticalCenter
                        text: downloadTools.statusText
                        color: downloadTools.statusWarning ? appWindow.theme.errorMessage : appWindow.theme.successMessage
                        clip: true
                        wrapMode: Text.Wrap
                        width: parent.width
                        font.pixelSize: 13*appWindow.fontZoom
                    }
                }

                CustomButton {
                    Layout.preferredHeight: height
                    Layout.alignment: Qt.AlignRight
                    visible: downloadTools.statusWarning && downloadTools.allowedToReportLastError
                    text: qsTr("Report problem") + App.loc.emptyString
                    onClicked: privacyDlg.open(downloadTools.lastFailedRequestId)
                }

                CustomButton {
                    id: cnclBtn
                    Layout.preferredHeight: height
                    Layout.alignment: Qt.AlignRight
                    text: qsTr("Cancel") + App.loc.emptyString
                    onClicked: downloadTools.doReject()
                }

                CustomButton {
                    id: okbtn
                    Layout.preferredHeight: height
                    Layout.alignment: Qt.AlignRight
                    text: (downloadTools.buildingDownload || downloadTools.buildingDownloadFinished ? qsTr("Download") : qsTr("OK")) + App.loc.emptyString
                    enabled: urlField.text.length > 0
                    blueBtn: true
                    alternateBtnPressed: cnclBtn.isPressed
                    onClicked: downloadTools.doOK()
                }
            }
        }
    }

    function newDownload()
    {
        if (!appWindow.canShowCreateDownloadDialog()) {
            return false;
        }

        downloadTools.reset();
        downloadTools.getUrlFromClipboard();
        root.open();
        root.forceActiveFocus();
    }

    function newDownloadByRequest(request)
    {
        downloadTools.newDownloadByRequest(request);
        root.open();
        root.forceActiveFocus();
    }

    BuildDownloadTools {
        id: downloadTools
        onCreateDownloadBeforeRequest: {
            appWindow.newDownloadAdded();
            root.close();
        }
        onCreateRequestSuccess: {
            tuneAddDownloadDlg.showRequestData(id);
            if (opened) {
                root.close();
            }
        }
        onReject: {
            root.close();
        }
    }

    onClosed: {
        downloadTools.doRejectLastFailedRequestId();
        appWindow.appWindowStateChanged();
    }

    Connections {
        target: appWindow
        onReportError: {
            if (failedId == downloadTools.lastFailedRequestId) {
                downloadTools.doReject();
            }
        }
    }

    function isBusy()
    {
        return urlField.text.length !== 0 ||
                downloadTools.isBusy();
    }
}
