import QtQuick 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
import org.freedownloadmanager.fdm 1.0

import Qt.labs.platform 1.0 as QtLabs

import "../../common/Tools"
import "../BaseElements"
import "../../common"

BaseDialog {
    id: root

    width: 542

    property var downloadsIds: []
    property var filesIndices: []
    property bool wrongFilePathWarning: false

    contentItem: BaseDialogItem {
        titleText: qsTr("Convert to mp4") + App.loc.emptyString
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
            Layout.leftMargin: 10
            Layout.rightMargin: 10
            spacing: 10


            BaseLabel {
                Layout.fillWidth: true
                text: qsTr("Save to") + App.loc.emptyString
            }

            RowLayout {
                height: folderBtn.implicitHeight + 1

                BaseTextField {
                    id: destinationDir
                    focus: true
                    Layout.fillWidth: true
                    onAccepted: root.doOK()
                    Keys.onEscapePressed: root.close();
                }

                CustomButton {
                    id: folderBtn
                    implicitWidth: 38
                    implicitHeight: 30
                    Layout.alignment: Qt.AlignRight
                    Layout.preferredHeight: height

                    Image {
                        source: Qt.resolvedUrl("../../images/desktop/pick_file.svg")
                        sourceSize.width: 37
                        sourceSize.height: 30
                        layer {
                            effect: ColorOverlay {
                                color: folderBtn.isPressed ? folderBtn.secondaryTextColor : folderBtn.primaryTextColor
                            }
                            enabled: true
                        }
                    }

                    onClicked: browseDlg.open()

                    QtLabs.FolderDialog {
                        id: browseDlg
                        folder: QtLabs.StandardPaths.writableLocation(QtLabs.StandardPaths.DownloadLocation)
                        acceptLabel: qsTr("Open") + App.loc.emptyString
                        rejectLabel: qsTr("Cancel") + App.loc.emptyString
                        onAccepted: destinationDir.text = App.tools.url(folder).toLocalFile()
                        Component.onCompleted: { destinationDir.text = App.tools.url(folder).toLocalFile() }
                    }
                }
            }

            RowLayout {
                Layout.topMargin: 10
                Layout.bottomMargin: 10
                Layout.alignment: Qt.AlignRight

                spacing: 5

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
                        font.pixelSize: 13
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
                    enabled: destinationDir.text.length > 0
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
    onClosed: appWindow.appWindowStateChanged()

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

    function showDialog(downloadsIds, filesIndices)
    {
        root.downloadsIds = downloadsIds;
        root.filesIndices = filesIndices;
        destinationDir.text = initialPath();
        wrongFilePathWarning = false;
        root.open();
    }

    function doOK() {
        if (checkFilePath()) {
            App.downloads.mgr.convertFilesToMp4(downloadsIds, filesIndices, destinationDir.text);
            if (isUserChangedPath())
                uiSettingsTools.settings.mp4ConverterDestinationDir = destinationDir.text;
            root.close();
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
