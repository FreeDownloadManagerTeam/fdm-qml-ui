import QtQuick 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.11
import QtQuick.Dialogs 1.3
import org.freedownloadmanager.fdm 1.0
import QtGraphicalEffects 1.0
import "../BaseElements"
import "../../common/Tools"

BaseDialog {
    id: root

    width: 542

    property string urlFieldText: urlField.text

    contentItem: BaseDialogItem {
        titleText: qsTr("Add download") + App.loc.emptyString
        onCloseClick: downloadTools.doReject()

        ColumnLayout {
            Layout.fillWidth: true
            Layout.leftMargin: 10
            Layout.rightMargin: 10
            spacing: 3

            BaseLabel {
                text: App.cfg.cdEnterUrlText + App.loc.emptyString
            }

            RowLayout {
                height: folderBtn.implicitHeight + 1
                width: parent.width

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

                CustomButton {
                    id: folderBtn
                    visible: App.cfg.cdShowOpenFileBtn
                    implicitWidth: 38
                    implicitHeight: 30
                    Layout.alignment: Qt.AlignRight
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
                Layout.preferredWidth: 200
                Layout.preferredHeight: 30
            }

            RowLayout {
                Layout.topMargin: 10
                Layout.bottomMargin: 10

                BusyIndicator
                {
                    visible: downloadTools.buildingDownload
                    running: visible
                    Layout.preferredHeight: 30
                    Layout.preferredWidth: 30
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
                        font.pixelSize: 13
                    }
                }

                CustomButton {
                    Layout.preferredHeight: height
                    Layout.alignment: Qt.AlignRight
                    visible: downloadTools.statusWarning
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
}
