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
                text: (appWindow.smallScreen ? qsTr("Convert to mp3") : qsTr("Convert to mp3 with adjustable bitrate")) + App.loc.emptyString
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

        BaseLabel {
            visible: wrongFilePathWarning
            text: qsTr("The path contains invalid characters") + App.loc.emptyString
            clip: true
            elide: Text.ElideRight
            font.pixelSize: 13
            color: appWindow.theme.errorMessage
        }

        BaseLabel {
            width: parent.width
            text: qsTr("Bitrate (quality)") + ':' + App.loc.emptyString
        }

        Row {
            width: parent.width
            spacing: 20

            ComboBox {
                id: quality

                model: [
                    {text: qsTr("Constant bitrate of value") + App.loc.emptyString, value: true},
                    {text: qsTr("Variable bitrate (VBR)") + App.loc.emptyString, value: false}]

                textRole: "text"

                delegate: Rectangle {
                    height: 35
                    width: parent.width
                    color: appWindow.theme.background
                    BaseLabel {
                        leftPadding: 6
                        anchors.verticalCenter: parent.verticalCenter
                        text: modelData.text
                        font.pixelSize: 13
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            quality.currentIndex = index;
                            quality.popup.close();
                            constantBitrateChecked = modelData.value
                        }
                    }
                }

                contentItem: Text {
                    id: contentItemText
                    text: quality.displayText
                    verticalAlignment: Text.AlignVCenter
                    color: theme.foreground
                    font.pixelSize: 13
                    leftPadding: 10
                }

                indicator: Image {
                    id: img2
                    anchors.verticalCenter: parent.verticalCenter
                    x: contentItemText.implicitWidth
                    source: Qt.resolvedUrl("../images/arrow_drop_down.svg")
                    sourceSize.width: 24
                    sourceSize.height: 24
                    layer {
                        effect: ColorOverlay {
                            color: appWindow.theme.foreground
                        }
                        enabled: true
                    }
                }

                Component.onCompleted: { currentIndex = model.findIndex(e => e.value == constantBitrateChecked); }
            }

            Label
            {
                text: "<a href='https://wikipedia.org/wiki/Variable_bitrate'>VBR?</a>"
                onLinkActivated: Qt.openUrlExternally(link)
                Material.accent: appWindow.theme.link
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        BitrateComboBox {
            id: constantBitrate
            visible: constantBitrateChecked
            constantBitrate: true
            maxComboWidth: destinationDir.width
        }

        BitrateComboBox {
            id: variableBitrate
            visible: !constantBitrateChecked
            constantBitrate: false
            maxComboWidth: destinationDir.width
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
        return uiSettingsTools.settings.mp3ConverterDestinationDir !== "" ?
                    uiSettingsTools.settings.mp3ConverterDestinationDir :
                    firstDownloadPath();
    }

    function isUserChangedPath()
    {
        return destinationDir.text !== initialPath();
    }

    Component.onCompleted: {
        constantBitrateChecked = uiSettingsTools.settings.mp3ConverterConstantBitrateEnabled;
        constantBitrate.minBitrate = uiSettingsTools.settings.mp3ConverterConstantBitrate;
        constantBitrate.maxBitrate = uiSettingsTools.settings.mp3ConverterConstantBitrate;
        variableBitrate.minBitrate = uiSettingsTools.settings.mp3ConverterVariableMinBitrate;
        variableBitrate.maxBitrate = uiSettingsTools.settings.mp3ConverterVariableMaxBitrate;
        destinationDir.text = initialPath();
        constantBitrate.reloadCombo();
        variableBitrate.reloadCombo();
        wrongFilePathWarning = false;
    }

    function doOK() {
        if (checkFilePath()) {
            var minBitrate = constantBitrateChecked ? constantBitrate.minBitrate : variableBitrate.minBitrate;
            var maxBitrate = constantBitrateChecked ? constantBitrate.maxBitrate : variableBitrate.maxBitrate;

            App.downloads.mgr.convertFilesToMp3(downloadsIds, filesIndices, destinationDir.text, minBitrate, maxBitrate);

            uiSettingsTools.settings.mp3ConverterConstantBitrateEnabled = constantBitrateChecked;
            uiSettingsTools.settings.mp3ConverterConstantBitrate = constantBitrate.minBitrate;
            uiSettingsTools.settings.mp3ConverterVariableMinBitrate = variableBitrate.minBitrate;
            uiSettingsTools.settings.mp3ConverterVariableMaxBitrate = variableBitrate.maxBitrate;
            if (isUserChangedPath())
                uiSettingsTools.settings.mp3ConverterDestinationDir = destinationDir.text;
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
