import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import org.freedownloadmanager.fdm 1.0
import "../../qt5compat"
import "../BaseElements"

Column
{
    visible: uiSettingsTools.settings.showTroubleshootingUi

    spacing: 10*appWindow.zoom
    width: parent.width

    SettingsGroupHeader
    {
        text: qsTr("Troubleshooting") + App.loc.emptyString
    }

    BaseLabel
    {
        id: lastError
        color: appWindow.theme.errorMessage
    }

    Row
    {
        anchors.left: parent.left
        spacing: 10*appWindow.zoom

        CustomButton
        {
            text: qsTr("Archive logs...") + App.loc.emptyString

            onClicked: logsFileDlg.open()

            FileDialog
            {
                id: logsFileDlg
                nameFilters: [qsTr("Zip files") + " (*.zip)" + App.loc.emptyString]
                fileMode: FileDialog.SaveFile
                onAccepted: lastError.text = App.archiveAppDataFolder(selectedFile, true) ? "" : qsTr("Failed");
            }
        }

        CustomButton
        {
            text: qsTr("Archive service data...") + App.loc.emptyString

            onClicked: dataFileDlg.open()

            FileDialog
            {
                id: dataFileDlg
                nameFilters: [qsTr("Zip files") + " (*.zip)" + App.loc.emptyString]
                fileMode: FileDialog.SaveFile
                onAccepted: lastError.text = App.archiveAppDataFolder(selectedFile, false) ? "" : qsTr("Failed");
            }
        }
    }

    RowLayout {
        anchors.left: parent.left

        BaseCheckBox
        {
            text: qsTr("Enable enhanced logging") + App.loc.emptyString
            checked: App.isLogVerbocityLevelDebug()
            onClicked: App.setLogVerbocityLevelDebug(checked)
            anchors.leftMargin: 0
            xOffset: 0
            textColor: appWindow.theme.settingsItem
            elideText: false
        }
        BaseLabel {
            text: "*"
            color: "red"
            font.pixelSize: 14*appWindow.fontZoom
            font.bold: true
            Layout.alignment: Qt.AlignTop
        }
    }

    RowLayout {
        anchors.left: parent.left

        BaseCheckBox
        {
            text: qsTr("Enable LT alerts logging") + App.loc.emptyString
            checked: App.isLtAlertsLoggingEnabled()
            onClicked: App.setLtAlertsLoggingEnabled(checked)
            anchors.leftMargin: 0
            xOffset: 0
            textColor: appWindow.theme.settingsItem
            elideText: false
        }
        BaseLabel {
            text: "*"
            color: "red"
            font.pixelSize: 14*appWindow.fontZoom
            font.bold: true
            Layout.alignment: Qt.AlignTop
        }
    }

    RowLayout {
        anchors.left: parent.left
        opacity: 0.5
        BaseLabel {
            text: "*"
            color: "red"
            font.pixelSize: 14*appWindow.fontZoom
            font.bold: true
            Layout.alignment: Qt.AlignTop
        }
        BaseLabel {
            text: qsTr("Restart is required") + App.loc.emptyString
        }
    }

    BaseHandCursorLabel {
        anchors.left: parent.left
        text: "<a href='#'>" + qsTr("Hide") + App.loc.emptyString + "</a>"
        onLinkActivated: uiSettingsTools.settings.showTroubleshootingUi = false
    }
}
