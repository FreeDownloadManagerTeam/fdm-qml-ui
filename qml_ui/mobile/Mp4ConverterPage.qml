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

    QtObject {
        id: d
        property bool accepting: false
    }

    header: BaseToolBar {
        RowLayout {
            anchors.fill: parent

            ToolbarBackButton {
                onClicked: {
                    d.accepting = false;
                    stackView.pop();
                }
            }

            ToolbarLabel {
                text: qsTr("Convert to mp4") + App.loc.emptyString
                Layout.fillWidth: true
            }

            DialogButton {
                text: qsTr("OK") + App.loc.emptyString
                enabled: !d.accepting && destinationDir.displayText.length > 0
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
                enabled: !d.accepting
                Layout.fillWidth: true
                selectByMouse: true
                inputMethodHints: Qt.ImhNoAutoUppercase | Qt.ImhNoPredictiveText | Qt.ImhSensitiveData
                wrapMode: TextInput.WrapAnywhere
                onAccepted: root.doOK()
            }

            RoundButton {
                visible: !App.rc.client.active
                enabled: !d.accepting
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

        BaseLabel {
            visible: wrongFilePathWarning
            text: qsTr("The path contains invalid characters") + App.loc.emptyString
            clip: true
            elide: Text.ElideRight
            font.pixelSize: 13
            color: appWindow.theme.errorMessage
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
        return App.toNativeSeparators(uiSettingsTools.settings.mp4ConverterDestinationDir !== "" ?
                    uiSettingsTools.settings.mp4ConverterDestinationDir :
                    firstDownloadPath());
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
        d.accepting = true;
        App.storages.isValidAbsoluteFilePath(App.fromNativeSeparators(destinationDir.text));
    }

    Connections
    {
        target: App.storages
        onIsValidAbsoluteFilePathResult: function(path, result) {
            if (d.accepting &&
                    path === App.fromNativeSeparators(destinationDir.text))
            {
                d.accepting = false;
                wrongFilePathWarning = !result;
                if (result)
                {
                    App.downloads.mgr.convertFilesToMp4(downloadsIds, filesIndices, destinationDir.text);
                    if (isUserChangedPath())
                        uiSettingsTools.settings.mp4ConverterDestinationDir = destinationDir.text;
                    stackView.pop();
                }
            }
        }
    }
}
