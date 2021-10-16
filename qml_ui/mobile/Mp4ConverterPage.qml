import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import "../qt5compat"
import QtQuick.Controls.Material 2.4
import org.freedownloadmanager.fdm 1.0
import "BaseElements"
import "../common/Tools"

Page {
    property var downloadsIds: []
    property var filesIndices: []
    property bool wrongFilePathWarning: false
    property bool constantBitrateChecked

    header: BaseToolBar {
        RowLayout {
            anchors.fill: parent

            ToolbarBackButton {
                onClicked: stackView.pop()
            }

            ToolbarLabel {
                text: qsTr("Convert to mp4") + App.loc.emptyString
                Layout.fillWidth: true
            }

            DialogButton {
                text: qsTr("OK") + App.loc.emptyString
                enabled: destinationDir.displayText.length > 0
                Layout.rightMargin: 10
                textColor: appWindow.theme.toolbarTextColor
                onClicked: doOK()
            }
        }
    }

    Column {
        anchors.fill: parent
        anchors.margins: 20
        anchors.leftMargin: appWindow.showBordersInDownloadsList ? parent.width * 0.1 : 20
        anchors.rightMargin: appWindow.showBordersInDownloadsList ? parent.width * 0.1 : 20
        spacing: 10

        BaseLabel
        {
            text: qsTr("Save to") + App.loc.emptyString
        }

        RowLayout{
            width: parent.width

            TextField
            {
                id: destinationDir
                Layout.fillWidth: true
                selectByMouse: true
                inputMethodHints: Qt.ImhNoAutoUppercase | Qt.ImhNoPredictiveText | Qt.ImhSensitiveData
                wrapMode: TextInput.WrapAnywhere
                onAccepted: root.doOK()
            }

            RoundButton {
                radius: 40
                width: 40
                height: 40
                flat: true
                icon.source: Qt.resolvedUrl("../images/download-item/folder.svg")
                icon.color: appWindow.theme.foreground
                icon.width: 18
                icon.height: 18
                onClicked: {
                    stackView.waPush(filePicker.filePickerPageComponent, {initiator: "convertPage", downloadId: -1});
                }
            }

            Connections {
                target: filePicker
                onFolderSelected: {
                    onFolderSelected: { destinationDir.text = folderName }
                }
            }
        }
    }

    function firstDownloadPath()
    {
        return downloadsIds.length ?
                    App.downloads.infos.info(downloadsIds[0]).destinationPath :
                    "";
    }

    function initialPath()
    {
        return uiSettingsTools.settings.mp4ConverterDestinationDir !== "" ?
                    uiSettingsTools.settings.mp4ConverterDestinationDir :
                    firstDownloadPath();
    }

    function isUserChangedPath()
    {
        return destinationDir.text !== initialPath();
    }

    Component.onCompleted: {
        destinationDir.text = initialPath();
        wrongFilePathWarning = false;
    }

    function doOK() {
        if (checkFilePath()) {
            App.downloads.mgr.convertFilesToMp4(downloadsIds, filesIndices, destinationDir.text);
            if (isUserChangedPath())
                uiSettingsTools.settings.mp4ConverterDestinationDir = destinationDir.text;
            stackView.pop();
        }
    }

    function checkFilePath() {
        if (!App.tools.isValidAbsoluteFilePath(destinationDir.text)) {
            wrongFilePathWarning = true;
            return false;
        }
        return true;
    }
}
