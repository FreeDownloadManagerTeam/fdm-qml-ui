import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import Qt.labs.platform 1.0 as QtLabs
import org.freedownloadmanager.fdm 1.0
import org.freedownloadmanager.fdm.abstractdownloadsui 1.0
import QtQuick.Controls.Material 2.4
import "../qt5compat"
import "../common"
import "../common/Tools"
import "./BaseElements"
import "./FilesTree"
import "./Dialogs"

Page {
    id: root

    property string pageName: "TuneAndAddDownloadPage"
    property double requestId: -1
    property var storages: []

    header: BaseToolBar {
        RowLayout {
            anchors.fill: parent

            ToolbarBackButton {
                onClicked: downloadTools.doReject()
            }

            ToolbarLabel {
                text: qsTr("New file") + App.loc.emptyString
                Layout.fillWidth: true
            }

            DialogButton {
                text: qsTr("Download") + App.loc.emptyString
                Layout.rightMargin: qtbug.rightMargin(0, 10)
                Layout.leftMargin: qtbug.leftMargin(0, 10)
                textColor: appWindow.theme.toolbarTextColor
                onClicked: accept()
                enabled: saveTo.currentText.length > 0 && downloadTools.hasWriteAccess
            }
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.topMargin: 20
        anchors.leftMargin: appWindow.showBordersInDownloadsList ? parent.width * 0.1 : 0
        anchors.rightMargin: appWindow.showBordersInDownloadsList ? parent.width * 0.1 : 0
        spacing: 10

        Column {
            id:saveColumn
            spacing: 2
            Layout.fillWidth: true
            Layout.leftMargin: 20
            Layout.rightMargin: 20

            Label {
                text: qsTr("Save to") + App.loc.emptyString
                anchors.left: parent.left
            }

            RowLayout {
                width: parent.width

                BaseComboBox {
                    id: saveTo
                    Layout.fillWidth: true
                    fontSize: 13
                    onAccepted: accept()
                    onCurrentTextChanged: queryBytesAvailable()
                    delegate: Rectangle {
                        height: 30
                        width: saveTo.width
                        color: appWindow.theme.background
                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 6
                            anchors.rightMargin: 6
                            BaseLabel {
                                Layout.fillWidth: true
                                Layout.alignment: Qt.AlignVCenter
                                text: modelData.text
                                font.pixelSize: saveTo.fontSize
                                horizontalAlignment: Text.AlignLeft
                                elide: Text.ElideRight
                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: {
                                        saveTo.currentIndex = index;
                                        saveTo.popup.close();
                                    }
                                }
                            }
                            Image {
                                visible: saveTo.model.length > 1
                                Layout.alignment: Qt.AlignVCenter
                                source: Qt.resolvedUrl("../images/desktop/clean.svg")
                                layer {
                                    effect: ColorOverlay {
                                        color: appWindow.theme.foreground
                                    }
                                    enabled: true
                                }
                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: {
                                        let etext = saveTo.editText;
                                        let p = modelData.path;
                                        let newIndex = index < saveTo.model.length - 1 ? index : 0;
                                        let m = saveTo.model;
                                        let __saveTo = saveTo;
                                        m.splice(index, 1);
                                        __saveTo.currentIndex = newIndex;
                                        __saveTo.model = m;
                                        App.recentFolders.removeFolder(p);
                                    }
                                }
                            }
                        }
                    }
                    Connections {
                        target: filePicker
                        onFolderSelected: {
                            onFolderSelected: updateCurrentFolder(folderName)
                        }
                    }
                }

                RoundButton {
                    visible: !App.rc.client.active
                    radius: 40
                    width: 40
                    height: 40
                    flat: true
                    icon.source: Qt.resolvedUrl("../images/download-item/folder.svg")
                    icon.color: appWindow.theme.foreground
                    icon.width: 18
                    icon.height: 18
                    onClicked: {
                        stackView.waPush(filePicker.filePickerPageComponent, {folder: saveTo.model[saveTo.currentIndex].path, initiator: "addDownload", downloadId: -1});
                    }
                }
            }
        }

        Column {
            id: fileNameColumn
            visible: downloadTools.filesCount === 1 || downloadTools.batchDownload
            Layout.fillWidth: true
            Layout.leftMargin: 20
            Layout.rightMargin: 20
            spacing : 2
            width: parent.width
            Label {
                anchors.left: parent.left
                text: qsTr("File name") + App.loc.emptyString
            }

            BaseTextField {
                id: fileName
                visible: downloadTools.filesCount === 1 || downloadTools.batchDownload
                width: parent.width
                Layout.fillWidth: true
                selectByMouse: true
                inputMethodHints: Qt.ImhNoPredictiveText | Qt.ImhSensitiveData
                text: downloadTools.fileName
                horizontalAlignment: Text.AlignLeft
                onAccepted: accept()
            }
        }

        BaseCheckBox {
            visible: !App.rc.client.active &&
                    !downloadTools.batchDownload &&
                    App.downloads.creator.downloadInfo(downloadTools.requestId, 0).hasLargeEnoughPreviewableMediaFile(40*1024*1024)

            text: qsTr("Play file while it is still downloading") + App.loc.emptyString

            Layout.leftMargin: 20

            onClicked: {
                let info = App.downloads.creator.downloadInfo(downloadTools.requestId, 0);

                if (info)
                {
                    info.flags = checked ?
                                info.flags | AbstractDownloadsUi.EnableMediaDownloadToPlayAsap :
                                info.flags & ~AbstractDownloadsUi.EnableMediaDownloadToPlayAsap;
                }
            }
        }

        SchedulerButton {
            highlighted: schedulerTools.schedulerCheckboxEnabled
            onClicked: {
                schedulerDlg.initialization();
                schedulerDlg.open();
            }
        }

        Rectangle {
            color: 'transparent'
            Layout.topMargin: 5
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.bottomMargin: 39

            border.color: filesTree.visible ? appWindow.theme.border : "transparent"

            FilesTree {
                id: filesTree
                visible: downloadInfo && downloadInfo.filesCount > 1
                downloadInfo: null
                createDownloadDialog: true

                property var selectedSize: filesTree.downloadInfo ? filesTree.downloadInfo.selectedSize : -1
                onSelectedSizeChanged: { downloadTools.fileSizeValueChanged(filesTree.selectedSize) }

                Rectangle {
                    height: 1
                    width: parent.width
                    anchors.top: parent.top
                    color: appWindow.theme.border
                }
            }
        }
    }

    //file size
    Rectangle {
        visible: downloadTools.fileSize >= 0 || downloadTools.freeDiskSpace >= 0 || !downloadTools.hasWriteAccess
        color: appWindow.theme.background
        anchors.bottom: parent.bottom
        width: parent.width
        height: 40

        BaseLabel {
            anchors.centerIn: parent
            color: !downloadTools.hasWriteAccess || downloadTools.notEnoughSpaceWarning ? appWindow.theme.errorMessage : appWindow.theme.foreground
            text: (!downloadTools.hasWriteAccess ? qsTr("No write access to the selected directory") :
                   (downloadTools.freeDiskSpace >= 0 && downloadTools.fileSize >= 0) ? qsTr("Size: %1 (Disk space: %2)").arg(App.bytesAsText(downloadTools.fileSize)).arg(App.bytesAsText(downloadTools.freeDiskSpace)) :
                   downloadTools.freeDiskSpace >= 0 ? qsTr("Disk space: %1").arg(App.bytesAsText(downloadTools.freeDiskSpace)) :
                   downloadTools.fileSize >= 0 ? qsTr("Size: %1").arg(App.bytesAsText(downloadTools.fileSize)) :
                   "") + App.loc.emptyString
            font.pixelSize: 14
        }
    }

    BuildDownloadTools {
        id: downloadTools
        requestId: root.requestId
        onCreateDownloadFromDialog: {
            stackView.pop();
            appWindow.newDownloadAdded();
        }
        onReject: {
            stackView.pop();
        }
        onFilePathChanged: updateCurrentFolder(filePath)
    }

    SchedulerDialog {
        id: schedulerDlg
    }

    SchedulerTools {
        id: schedulerTools
        tuneAndDownloadDialog: true
    }

    onRequestIdChanged: {
        var info = App.downloads.creator.downloadInfo(requestId, 0);
        filesTree.downloadInfo = info;
        schedulerTools.buildScheduler([info.id]);
    }

    Component.onCompleted: {
        defineStorages();
        downloadTools.initSubtitlesDefaults();
        downloadTools.getNameAndPath();
        defineFolderList();
//        if (forceDownload) {
//            downloadTools.addDownloadFromDialog();
//        }
    }

    function defineStorages() {
        for (var i = 0; i < App.storages.storagesCount(); ++i) {
            storages[i] = App.storages.storageInfo(i);
        }
    }

    function shortUrl(path) {
        var storage = storages.filter(function (s) { return path.startsWith(s.unrestrictedPath) });
        path = storage.length > 0 ? path.replace(storage[0].unrestrictedPath, storage[0].label) : path;
        path = path.replace(/\/$/, '');//remove last slash
        return App.toNativeSeparators(path);
    }

    function defineFolderList() {
        var folderList = App.recentFolders.list;
        let m = [];
        for (var i = 0; i < folderList.length; i++)
            m.push({'text': shortUrl(folderList[i]), 'path': folderList[i]});
        saveTo.model = m;
        updateCurrentFolder(downloadTools.filePath);
    }

    function updateCurrentFolder(folderName) {
        var index = saveTo.model.findIndex(item => App.toNativeSeparators(item.path) === App.toNativeSeparators(folderName));

        if (index >= 0) {
            saveTo.currentIndex = index;
         } else {
            index = saveTo.model.length;
            let m = saveTo.model;
            m.push({'text': shortUrl(folderName), 'path': folderName});
            saveTo.model = m;
            saveTo.currentIndex = index;
        }
    }

    function accept() {
        downloadTools.onFileNameTextChanged(fileName.displayText);
        downloadTools.onFilePathTextChanged(saveTo.model[saveTo.currentIndex].path);
        downloadTools.addDownloadFromDialog();
        schedulerTools.doOK();
    }

    function queryBytesAvailable() {
        if (saveTo.currentIndex >= 0 && saveTo.currentIndex < saveTo.model.length) {
            App.storages.queryBytesAvailable(saveTo.model[saveTo.currentIndex].path)
            App.storages.queryIfHasWriteAccess(saveTo.model[saveTo.currentIndex].path);
        }
    }

    Connections {
        target: App.storages
        onBytesAvailableResult: (path, available) => {
            if (path == saveTo.model[saveTo.currentIndex].path) {
                downloadTools.freeDiskSpace = available;
            }
        }
        onHasWriteAccessResult: (path, result) => {
            if (path == saveTo.model[saveTo.currentIndex].path) {
                downloadTools.hasWriteAccess = result;
            }
        }
    }

    onVisibleChanged: queryBytesAvailable()

    Connections {
        target: Qt.application
        onActiveChanged: queryBytesAvailable()
    }
}
