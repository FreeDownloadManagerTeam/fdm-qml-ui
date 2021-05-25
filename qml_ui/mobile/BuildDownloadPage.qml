import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.4
import org.freedownloadmanager.fdm 1.0
import "../common/Tools"
import "BaseElements"


Page {
    id: root

    property string pageName: "BuildDownloadPage"
    property var downloadRequest

    header: BaseToolBar {
        RowLayout {
            anchors.fill: parent

            ToolbarBackButton {
                onClicked: downloadTools.doReject()
            }

            ToolbarLabel {
                text: qsTr("Add download") + App.loc.emptyString
                Layout.fillWidth: true
            }

            DialogButton {
                text: (downloadTools.buildingDownload || downloadTools.buildingDownloadFinished ? qsTr("Download") : qsTr("OK")) + App.loc.emptyString
                Layout.rightMargin: 10
                textColor: appWindow.theme.toolbarTextColor
                enabled: url.text.length > 0 && !downloadTools.failed()
                onClicked: url.accepted()
            }
        }
    }

    Column {
        anchors.fill: parent
        anchors.margins: 20
        anchors.leftMargin: appWindow.showBordersInDownloadsList ? parent.width * 0.1 : 20
        anchors.rightMargin: appWindow.showBordersInDownloadsList ? parent.width * 0.1 : 20
        spacing: 10

        ColumnLayout {
            width: parent.width
            spacing: 2

            Label
            {
                text: App.cfg.cdEnterUrlText + App.loc.emptyString
            }

            RowLayout{
                TextField
                {
                    id: url
                    Layout.fillWidth: true
                    selectByMouse: true
                    focus: true
                    text: downloadTools.urlText
                    onDisplayTextChanged: downloadTools.onUrlTextChanged(displayText)
                    enabled: !downloadTools.buildingDownload && !downloadTools.buildingDownloadFinished
                    onAccepted: { if (downloadTools.urlCheck(url.displayText)) {downloadTools.doOK()}}
                    inputMethodHints: Qt.ImhNoAutoUppercase | Qt.ImhNoPredictiveText | Qt.ImhSensitiveData
                    wrapMode: TextInput.WrapAnywhere
                }

                RoundButton {
                    visible: App.cfg.cdShowOpenFileBtn
                    radius: 40
                    width: 40
                    height: 40
                    flat: true
                    onClicked: {
                        stackView.waPush(filePicker.filePickerPageComponent, {initiator: "addDownload", downloadId: -1, onlyFolders: false});
                    }
                    Layout.alignment: Qt.AlignTop
                    icon.source: Qt.resolvedUrl("../images/download-item/folder.svg")
                    icon.color: appWindow.theme.foreground
                    icon.width: 18
                    icon.height: 18
                }

                Connections {
                    target: filePicker
                    onFileSelected: {
                        onFileSelected: {
                            url.text = fileName;
                            url.accepted();
                        }
                    }
                }
            }
        }

        RowLayout {
            width: parent.width
            height: 40

            BusyIndicator
            {
                visible: downloadTools.buildingDownload
                running: downloadTools.buildingDownload
                Layout.alignment: Qt.AlignVCenter
            }

            Label
            {
                text: downloadTools.statusText
                color: downloadTools.statusWarning ? appWindow.theme.errorMessage : appWindow.theme.successMessage
                Layout.alignment: Qt.AlignVCenter
                Layout.fillWidth: true
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            }
        }

        RoundButton {
            text: qsTr("Report problem") + App.loc.emptyString
            visible: downloadTools.lastFailedRequestId !== -1 && downloadTools.statusWarning
            icon.source: Qt.resolvedUrl("../images/mobile/bug_report.svg")
            icon.color: appWindow.theme.toolbarTextColor
            icon.width: 14
            icon.height: 14
            Material.foreground: appWindow.theme.toolbarTextColor
            Material.background: appWindow.theme.selectModeBarAndPlusBtn
            implicitWidth: 166
            height: 48
            flat: true
            font.capitalization: Font.MixedCase
            anchors.horizontalCenter: parent.horizontalCenter
            onClicked: privacyDlg.open(downloadTools.lastFailedRequestId)
        }
    }

    function resetUi()
    {
        url.text = "";
        var text = App.clipboard.text;
        urlTools.checkIfAcceptableUrl(text, function(acceptable, modulesUids, urlDescriptions, downloadsTypes){
            if (acceptable) {
                url.text = text;
                url.selectAll();
                url.forceActiveFocus();
            }
        });
    }

    Component.onCompleted: {
        if (downloadRequest) {
            downloadTools.newDownloadByRequest(downloadRequest);
        } else {
            resetUi();
        }
    }

    BuildDownloadTools {
        id: downloadTools
        onCreateDownloadBeforeRequest: {
            appWindow.newDownloadAdded();
            stackView.pop();
        }
        onCreateRequestSuccess: {
            stackView.replace('TuneAndAddDownloadPage.qml', {requestId:id});
        }
        onReject: {
            stackView.pop();
        }

        function urlCheck(url) {
            if (!appWindow.ytSupported && App.isDownloadForbidden(url)) {
                downloadTools.statusWarning = true;
                downloadTools.statusText = qsTr("Downloading from this site is not allowed");
                return false;
            }
            return true;
        }
    }

    AcceptableUrlTool {
        id: urlTools
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
