import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs
import QtQuick.Controls.Material
import org.freedownloadmanager.fdm
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
                Layout.rightMargin: qtbug.rightMargin(0, 10)
                Layout.leftMargin: qtbug.leftMargin(0, 10)
                textColor: appWindow.theme.toolbarTextColor
                enabled: url.text.length > 0 && (!downloadTools.failed() || downloadTools.canIgnoreError())
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
                BaseTextField
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
                    horizontalAlignment: Label.AlignLeft
                }

                RoundButton {
                    visible: App.cfg.cdShowOpenFileBtn
                    radius: 40
                    width: 40
                    height: 40
                    flat: true
                    onClicked: openFileDlg.open()
                    Layout.alignment: Qt.AlignTop
                    icon.source: Qt.resolvedUrl("../images/download-item/folder.svg")
                    icon.color: appWindow.theme.foreground
                    icon.width: 18
                    icon.height: 18

                    FileDialog
                    {
                        id: openFileDlg
                        nameFilters: App.cfg.cdOpenFileDlgNameFilters ? App.cfg.cdOpenFileDlgNameFilters : ["*"]
                        fileMode: FileDialog.OpenFile
                        flags: FileDialog.ReadOnly
                        onAccepted: {
                            url.text = selectedFile;
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
                visible: !downloadTools.lastError
                text: downloadTools.statusText
                color: downloadTools.statusWarning ? appWindow.theme.errorMessage : appWindow.theme.successMessage
                Layout.alignment: Qt.AlignVCenter
                Layout.fillWidth: true
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            }

            BaseErrorLabel
            {
                visible: downloadTools.lastError
                error: downloadTools.lastError
                shortVersion: false
                showIcon: false
                resourceUrl: App.tools.urlFromUserInput(downloadTools.urlText)
                Layout.alignment: Qt.AlignVCenter
                Layout.fillWidth: true
            }
        }

        RoundButton {
            text: qsTr("Report problem") + App.loc.emptyString
            visible: downloadTools.lastFailedRequestId !== -1 && (downloadTools.statusWarning || downloadTools.lastError) && downloadTools.allowedToReportLastError
            icon.source: Qt.resolvedUrl("../images/mobile/bug_report.svg")
            icon.color: appWindow.theme.toolbarTextColor
            icon.width: 14
            icon.height: 14
            Material.foreground: appWindow.theme.toolbarTextColor
            Material.background: appWindow.theme.selectModeBarAndPlusBtn
            leftPadding: 20
            rightPadding: 20
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
        onCreateRequestSuccess: (id) => {
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
        onReportError: (failedId) => {
            if (failedId == downloadTools.lastFailedRequestId) {
                downloadTools.doReject();
            }
        }
    }
}
