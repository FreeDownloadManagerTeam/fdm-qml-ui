import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs
import org.freedownloadmanager.fdm
import "../BaseElements"

Page
{
    id: root

    header: PageHeaderWithBackArrow {
        pageTitle: qsTr("Troubleshooting") + App.loc.emptyString
        onPopPage: root.StackView.view.pop()
    }

    RowLayout
    {
        spacing: 0

        Item
        {
            implicitWidth: 20
            implicitHeight: 1
        }

        ColumnLayout
        {
            spacing: 10

            Item
            {
                implicitHeight: 10
                implicitWidth: 1
            }

            BaseLabel
            {
                id: lastError
                visible: text
                color: appWindow.theme.errorMessage
            }

            BaseLabel
            {
                text: "<a href='#'>" + qsTr("Archive logs...") + App.loc.emptyString + "</a>"

                onLinkActivated: logsFileDlg.open()

                FileDialog
                {
                    id: logsFileDlg
                    nameFilters: [qsTr("Zip files") + " (*.zip)" + App.loc.emptyString]
                    fileMode: FileDialog.SaveFile
                    onAccepted: lastError.text = App.archiveAppDataFolder(selectedFile, true) ? "" : qsTr("Failed");
                }
            }

            BaseLabel
            {
                text: "<a href='#'>" + qsTr("Archive service data...") + App.loc.emptyString + "</a>"

                onLinkActivated: dataFileDlg.open()

                FileDialog
                {
                    id: dataFileDlg
                    nameFilters: [qsTr("Zip files") + " (*.zip)" + App.loc.emptyString]
                    fileMode: FileDialog.SaveFile
                    onAccepted: lastError.text = App.archiveAppDataFolder(selectedFile, false) ? "" : qsTr("Failed");
                }
            }

            RowLayout {
                BaseCheckBox
                {
                    text: qsTr("Enable enhanced logging") + App.loc.emptyString
                    checked: App.isLogVerbocityLevelDebug()
                    onClicked:App.setLogVerbocityLevelDebug(checked)
                }

                BaseLabel {
                    text: "*"
                    color: "red"
                    font.pixelSize: 14
                    font.bold: true
                    Layout.alignment: Qt.AlignTop
                }
            }

            RowLayout {
                BaseCheckBox
                {
                    text: qsTr("Enable LT alerts logging") + App.loc.emptyString
                    checked: App.isLtAlertsLoggingEnabled()
                    onClicked: App.setLtAlertsLoggingEnabled(checked)
                }
                BaseLabel {
                    text: "*"
                    color: "red"
                    font.pixelSize: 14
                    font.bold: true
                    Layout.alignment: Qt.AlignTop
                }
            }

            RowLayout {
                BaseCheckBox
                {
                    text: qsTr("Enable downloads management logging") + App.loc.emptyString
                    checked: App.isDownloadsManagementLoggingEnabled()
                    onClicked: App.setDownloadsManagementLoggingEnabled(checked)
                }
                BaseLabel {
                    text: "*"
                    color: "red"
                    font.pixelSize: 14
                    font.bold: true
                    Layout.alignment: Qt.AlignTop
                }
            }

            RowLayout {
                opacity: 0.5
                BaseLabel {
                    text: "*"
                    color: "red"
                    font.pixelSize: 14
                    font.bold: true
                    Layout.alignment: Qt.AlignTop
                }
                BaseLabel {
                    text: qsTr("Restart is required") + App.loc.emptyString
                }
            }

            BaseLabel {
                text: "<a href='#'>" + "Show GP vote offer UI" + App.loc.emptyString + "</a>"
                onLinkActivated: voteBlock.start()
            }

            BaseLabel {
                text: "<a href='#'>" + qsTr("Hide") + App.loc.emptyString + "</a>"
                onLinkActivated: {
                    uiSettingsTools.settings.showTroubleshootingUi = false
                    root.StackView.view.pop()
                }
            }
        }
    }
}
