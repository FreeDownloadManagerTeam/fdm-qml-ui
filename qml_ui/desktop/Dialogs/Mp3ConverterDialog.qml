import QtQuick 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import "../../qt5compat"
import org.freedownloadmanager.fdm 1.0

import Qt.labs.platform 1.0 as QtLabs

import "../../common/Tools"
import "../BaseElements"
import "../../common"

BaseDialog {
    id: root

    property var downloadsIds: []
    property var filesIndices: []
    property bool wrongFilePathWarning: false

    QtObject {
        id: d
        property bool accepting: false
    }

    contentItem: BaseDialogItem {
        titleText: qsTr("Convert to mp3 with adjustable bitrate") + App.loc.emptyString
        focus: true

        onCloseClick: {
            root.close();
        }

        Keys.onEscapePressed: {
            root.close();
        }

        Keys.onReturnPressed: {
            root.close();
        }

        ColumnLayout {
            Layout.fillWidth: true
            Layout.leftMargin: 10*appWindow.zoom
            Layout.rightMargin: 10*appWindow.zoom
            spacing: 10*appWindow.zoom


            BaseLabel {
                Layout.fillWidth: true
                text: qsTr("Save to") + App.loc.emptyString
            }

            RowLayout {

                BaseTextField {
                    id: destinationDir
                    enabled: !d.accepting
                    focus: true
                    Layout.fillWidth: true
                    onAccepted: root.doOK()
                    Keys.onEscapePressed: root.close();
                }

                PickFileButton {
                    id: folderBtn
                    enabled: !d.accepting
                    Layout.alignment: Qt.AlignRight
                    Layout.fillHeight: true

                    onClicked: browseDlg.open()

                    QtLabs.FolderDialog {
                        id: browseDlg
                        folder: QtLabs.StandardPaths.writableLocation(QtLabs.StandardPaths.DownloadLocation)
                        acceptLabel: qsTr("Open") + App.loc.emptyString
                        rejectLabel: qsTr("Cancel") + App.loc.emptyString
                        onAccepted: destinationDir.text = App.toNativeSeparators(App.tools.url(folder).toLocalFile())
                        Component.onCompleted: { destinationDir.text = App.toNativeSeparators(App.tools.url(folder).toLocalFile()) }
                    }
                }
            }

            BaseLabel {
                Layout.fillWidth: true
                text: qsTr("Bitrate (quality)") + ':' + App.loc.emptyString
            }

            ButtonGroup {
                id: qualityGroup
            }

            RowLayout {
                BaseRadioButton {
                    id: constantRadioBtn
                    text: qsTr("Constant bitrate of value") + ':' + App.loc.emptyString
                    ButtonGroup.group: qualityGroup
                }

                BitrateComboBox {
                    id: constantBitrate
                    enabled: constantRadioBtn.checked
                    constantBitrate: true
                }
            }

            RowLayout {
                BaseRadioButton {
                    id: variableRadioBtn
                    text: qsTr("Variable bitrate (VBR)") + ':' + App.loc.emptyString
                    ButtonGroup.group: qualityGroup
                }

                BitrateComboBox {
                    id: variableBitrate
                    enabled: variableRadioBtn.checked
                    constantBitrate: false
                }

                BaseHyperLabel {
                    text: "<a href='https://wikipedia.org/wiki/Variable_bitrate'>?</a>"
                }
            }


            RowLayout {
                Layout.topMargin: 10*appWindow.zoom
                Layout.bottomMargin: 10*appWindow.zoom
                Layout.alignment: Qt.AlignRight

                spacing: 5*appWindow.zoom

                Rectangle {
                    color: "transparent"
                    height: cnclBtn.height
                    Layout.fillWidth: true

                    BaseLabel {
                        visible: wrongFilePathWarning
                        anchors.verticalCenter: parent.verticalCenter
                        text: qsTr("The path contains invalid characters") + App.loc.emptyString
                        clip: true
                        elide: Text.ElideRight
                        width: parent.width
                        font.pixelSize: 13*appWindow.fontZoom
                        color: "#585759"
                    }
                }

                CustomButton {
                    id: cnclBtn
                    text: qsTr("Cancel") + App.loc.emptyString
                    onClicked: {
                        root.close();
                    }
                }

                CustomButton {
                    text: qsTr("OK") + App.loc.emptyString
                    enabled: !d.accepting && destinationDir.text.length > 0
                    blueBtn: true
                    alternateBtnPressed: cnclBtn.isPressed
                    onClicked: {
                        root.doOK();
                    }
                }
            }
        }
    }

    onOpened: forceActiveFocus()
    onClosed: {
        d.accepting = false;
        appWindow.appWindowStateChanged();
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
        return App.fromNativeSeparators(destinationDir.text) !== initialPath();
    }

    function showDialog(downloadsIds, filesIndices)
    {
        root.downloadsIds = downloadsIds;
        root.filesIndices = filesIndices;
        constantRadioBtn.checked = uiSettingsTools.settings.mp3ConverterConstantBitrateEnabled;
        constantBitrate.minBitrate = uiSettingsTools.settings.mp3ConverterConstantBitrate;
        constantBitrate.maxBitrate = uiSettingsTools.settings.mp3ConverterConstantBitrate;
        variableRadioBtn.checked = !uiSettingsTools.settings.mp3ConverterConstantBitrateEnabled;
        variableBitrate.minBitrate = uiSettingsTools.settings.mp3ConverterVariableMinBitrate;
        variableBitrate.maxBitrate = uiSettingsTools.settings.mp3ConverterVariableMaxBitrate;
        destinationDir.text = App.toNativeSeparators(initialPath());
        constantBitrate.reloadCombo();
        variableBitrate.reloadCombo();
        wrongFilePathWarning = false;
        root.open();
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
                    var minBitrate = constantBitrate.enabled ? constantBitrate.minBitrate : variableBitrate.minBitrate;
                    var maxBitrate = constantBitrate.enabled ? constantBitrate.maxBitrate : variableBitrate.maxBitrate;
                    App.downloads.mgr.convertFilesToMp3(downloadsIds, filesIndices, App.fromNativeSeparators(destinationDir.text), minBitrate, maxBitrate);

                    uiSettingsTools.settings.mp3ConverterConstantBitrateEnabled = constantBitrate.enabled;
                    uiSettingsTools.settings.mp3ConverterConstantBitrate = constantBitrate.minBitrate;
                    uiSettingsTools.settings.mp3ConverterVariableMinBitrate = variableBitrate.minBitrate;
                    uiSettingsTools.settings.mp3ConverterVariableMaxBitrate = variableBitrate.maxBitrate;
                    if (isUserChangedPath())
                        uiSettingsTools.settings.mp3ConverterDestinationDir = App.fromNativeSeparators(destinationDir.text);
                    root.close();
                }
            }
        }
    }
}
