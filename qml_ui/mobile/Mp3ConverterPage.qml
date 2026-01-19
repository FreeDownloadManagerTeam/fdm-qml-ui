import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Controls.Material
import org.freedownloadmanager.fdm
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
                text: (appWindow.smallScreen ? qsTr("Convert to mp3") : qsTr("Convert to mp3 with adjustable bitrate")) + App.loc.emptyString
                Layout.fillWidth: true
            }

            DialogButton {
                text: qsTr("OK") + App.loc.emptyString
                enabled: !d.accepting && destinationDir.displayText.length > 0
                Layout.rightMargin: qtbug.rightMargin(0, 10)
                Layout.leftMargin: qtbug.leftMargin(0, 10)
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
            anchors.left: parent.left
            text: qsTr("Save to") + App.loc.emptyString
        }

        RowLayout{
            width: parent.width

            BaseTextField
            {
                id: destinationDir
                enabled: !d.accepting
                Layout.fillWidth: true
                selectByMouse: true
                inputMethodHints: Qt.ImhNoAutoUppercase | Qt.ImhNoPredictiveText | Qt.ImhSensitiveData
                horizontalAlignment: Text.AlignLeft
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

        BaseLabel {
            width: parent.width
            text: qsTr("Bitrate (quality)") + ':' + App.loc.emptyString
        }

        Row {
            width: parent.width
            spacing: 20

            BaseComboBox {
                id: quality

                model: [
                    {text: qsTr("Constant bitrate of value") + App.loc.emptyString, value: true},
                    {text: qsTr("Variable bitrate (VBR)") + App.loc.emptyString, value: false}]

                Component.onCompleted: { currentIndex = model.findIndex(e => e.value == constantBitrateChecked); }

                onActivated: index => constantBitrateChecked = model[index].value
            }

            Label
            {
                text: "<a href='https://wikipedia.org/wiki/Variable_bitrate'>VBR?</a>"
                onLinkActivated: Qt.openUrlExternally(link)
                Material.accent: appWindow.theme.link
                anchors.verticalCenter: parent.verticalCenter
                horizontalAlignment: Text.AlignLeft
            }
        }

        BitrateComboBox {
            id: constantBitrate
            visible: constantBitrateChecked
            constantBitrate: true
            maxComboWidth: destinationDir.width
            anchors.left: parent.left
        }

        BitrateComboBox {
            id: variableBitrate
            visible: !constantBitrateChecked
            constantBitrate: false
            maxComboWidth: destinationDir.width
            anchors.left: parent.left
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
        return App.toNativeSeparators(uiSettingsTools.settings.mp3ConverterDestinationDir !== "" ?
                    uiSettingsTools.settings.mp3ConverterDestinationDir :
                    firstDownloadPath());
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
        }
    }
}
