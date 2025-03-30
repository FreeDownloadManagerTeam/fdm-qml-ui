import QtQuick 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.11
import QtQuick.Window 2.12
import Qt.labs.platform 1.1
import "../../qt5compat"
import org.freedownloadmanager.fdm 1.0
import "../BaseElements"
import "../../common"
import "../../common/Tools"

BaseStandaloneCapableDialog {
    id: root

    readonly property int preferredWidth: 540*appWindow.fontZoom

    height: standalone ?
                Math.min(implicitHeight, Screen.height - 200) :
                Math.min(implicitHeight, appWindow.height - 50)
    width: (standalone ?
               Math.min(preferredWidth, Screen.width - 200) :
               Math.min(preferredWidth, appWindow.width - 50)) + __bugwaCounter

    title: standalone ? "" : (qsTr("Add download") + App.loc.emptyString)

    contentItem: BaseDialogItem {
        spacing: 0 // weird layout bug workaround
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 3*appWindow.zoom

            BaseLabel {
                dialogLabel: true
                text: App.cfg.cdEnterUrlText + App.loc.emptyString
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 8*appWindow.zoom

                BaseTextField {
                    id: urlField
                    focus: true
                    Layout.fillWidth: true
                    Layout.preferredHeight: Math.max(urlField.implicitHeight, folderBtn.implicitHeight)
                    text: downloadTools.urlText
                    onTextChanged: downloadTools.onUrlTextChanged(text)
                    onAccepted: downloadTools.doOK()
                    enabled: !downloadTools.buildingDownload && !downloadTools.buildingDownloadFinished
                    Keys.onEscapePressed: downloadTools.doReject()
                }

                PickFileButton {
                    id: folderBtn
                    visible: App.cfg.cdShowOpenFileBtn
                    toBrowseForFolder: false
                    Layout.alignment: Qt.AlignRight
                    Layout.preferredHeight: Math.max(urlField.implicitHeight, folderBtn.implicitHeight)
                    onClicked: browseDlg.open()
                    FileDialog {
                        id: browseDlg
                        nameFilters: [ "Files (" + App.cfg.cdOpenFileDlgNameFilters + ')' ]
                        onAccepted: {
                            downloadTools.onUrlTextChanged(selectedFile);
                            downloadTools.doOK();
                        }
                    }
                }
            }

            ModulesCombobox {
                Layout.preferredWidth: 200*appWindow.zoom
                Layout.preferredHeight: 30*appWindow.zoom
            }

            BaseLabel {
                visible: text
                text: downloadTools.lastError ? "" : downloadTools.statusText
                color: downloadTools.statusWarning ? appWindow.theme.errorMessage : appWindow.theme.successMessage
                wrapMode: Text.Wrap
                font.pixelSize: 13*appWindow.fontZoom
                Layout.fillWidth: true
                Layout.topMargin: 10*appWindow.zoom
                Layout.bottomMargin: 10*appWindow.zoom
            }

            BaseErrorLabel {
                visible: downloadTools.lastError
                error: downloadTools.lastError
                shortVersion: false
                showIcon: false
                resourceUrl: App.tools.urlFromUserInput(downloadTools.urlText)
                Layout.fillWidth: true
                Layout.topMargin: 10*appWindow.zoom
                Layout.bottomMargin: 10*appWindow.zoom
            }

            RowLayout {
                Layout.topMargin: 10*appWindow.zoom

                BusyIndicator
                {
                    visible: downloadTools.buildingDownload
                    running: visible
                    Layout.preferredHeight: 30*appWindow.zoom
                    Layout.preferredWidth: 30*appWindow.zoom
                    Layout.alignment: Qt.AlignLeft
                }

                Item {
                    Layout.fillWidth: true
                    implicitHeight: 1
                }

                BaseButton {
                    Layout.alignment: Qt.AlignRight
                    visible: (downloadTools.statusWarning || downloadTools.lastError) && downloadTools.allowedToReportLastError
                    text: qsTr("Report problem") + App.loc.emptyString
                    onClicked: privacyDlg.open(downloadTools.lastFailedRequestId)
                }

                BaseButton {
                    id: cnclBtn
                    Layout.alignment: Qt.AlignRight
                    text: qsTr("Cancel") + App.loc.emptyString
                    onClicked: downloadTools.doReject()
                }

                BaseButton {
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
        onCreateRequestSuccess: (id) => {
            tuneAddDownloadDlg.showRequestData(id);
            if (opened) {
                root.close();
            }
        }
        onReject: {
            root.close();
        }
    }

    onCloseClick: downloadTools.doReject()

    onClosed: {
        downloadTools.doRejectLastFailedRequestId();
        appWindow.appWindowStateChanged();
    }

    Connections {
        target: appWindow
        onReportError: failedId => {
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

    ////////////////////////////////////////////////////////////////////////////////////
    // Qt 6.4.3 Layouts bug workaround
    // TODO: remove it when switched to Qt 6.8.2+
    property int __bugwaCounter: 0
    property int __bugwaCounter2: App.qtVersion() === "6.4.3" ? 0 : 1
    Timer {
        id: bugwa
        interval: 10
        repeat: true
        onTriggered: {
           __bugwaCounter = __bugwaCounter ? 0 : 1;
            if (++__bugwaCounter2 * interval / 1000.0 >= 0.3)
            {
                stop();
                __bugwaCounter = 0;
            }
        }
    }
    onOpened: {
        if (!__bugwaCounter2)
            bugwa.start();
    }
    ////////////////////////////////////////////////////////////////////////////////////
}
