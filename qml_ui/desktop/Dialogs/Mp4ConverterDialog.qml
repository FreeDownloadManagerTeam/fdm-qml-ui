import QtQuick
import QtCore
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs
import org.freedownloadmanager.fdm

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

    title: qsTr("Convert to mp4") + App.loc.emptyString
    onCloseClick: root.close()

    contentItem: BaseDialogItem {
        focus: true

        Keys.onEscapePressed: {
            root.close();
        }

        Keys.onReturnPressed: {
            root.close();
        }

        ColumnLayout {
            Layout.fillWidth: true
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
                    Layout.minimumWidth: 500*appWindow.fontZoom
                    onAccepted: root.doOK()
                    Keys.onEscapePressed: root.close();
                }

                PickFileButton {
                    id: folderBtn
                    enabled: !d.accepting
                    Layout.alignment: Qt.AlignRight
                    Layout.fillHeight: true

                    onClicked: browseDlg.open()

                    FolderDialog {
                        id: browseDlg
                        currentFolder: StandardPaths.writableLocation(StandardPaths.DownloadLocation)
                        acceptLabel: qsTr("Open") + App.loc.emptyString
                        rejectLabel: qsTr("Cancel") + App.loc.emptyString
                        onAccepted: destinationDir.text = App.toNativeSeparators(App.tools.url(currentFolder).toLocalFile())
                        Component.onCompleted: { destinationDir.text = App.toNativeSeparators(App.tools.url(currentFolder).toLocalFile()) }
                    }
                }
            }

            RowLayout {
                Layout.topMargin: 10*appWindow.zoom
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

                BaseButton {
                    id: cnclBtn
                    text: qsTr("Cancel") + App.loc.emptyString
                    onClicked: {
                        root.close();
                    }
                }

                BaseButton {
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
        return uiSettingsTools.settings.mp4ConverterDestinationDir !== "" ?
                    uiSettingsTools.settings.mp4ConverterDestinationDir :
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
        destinationDir.text = App.toNativeSeparators(initialPath());
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
                    App.downloads.mgr.convertFilesToMp4(downloadsIds, filesIndices, App.fromNativeSeparators(destinationDir.text));
                    if (isUserChangedPath())
                        uiSettingsTools.settings.mp4ConverterDestinationDir = App.fromNativeSeparators(destinationDir.text);
                    root.close();
                }
            }
        }
    }
}
