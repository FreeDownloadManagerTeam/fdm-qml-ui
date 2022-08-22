import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import Qt.labs.platform 1.0 as QtLabs
import org.freedownloadmanager.fdm 1.0
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
                Layout.rightMargin: 10
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
            }

            RowLayout {
                width: parent.width

                ComboBox {
                    id: saveTo
                    model: ListModel {}
                    textRole: "label"
                    Layout.fillWidth: true
                    onAccepted: accept()
                    onCurrentTextChanged: queryBytesAvailable()
                    delegate: Rectangle {
                        height: 30
                        width: parent.width
                        color: appWindow.theme.background
                        BaseLabel {
                            leftPadding: 6
                            anchors.verticalCenter: parent.verticalCenter
                            text: label
                            font.pixelSize: 13
                        }
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                saveTo.currentIndex = index;
                                saveTo.popup.close();
                            }
                        }
                    }
                    contentItem: Text {
                        text: saveTo.currentText
                        verticalAlignment: Text.AlignVCenter
                        color: theme.foreground
                        font.pixelSize: 13
                        leftPadding: 6
                        elide: Text.ElideRight
                    }
                    indicator: Image {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right: parent.right
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
                        stackView.waPush(filePicker.filePickerPageComponent, {folder: saveTo.model.get(saveTo.currentIndex).path, initiator: "addDownload", downloadId: -1});
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
                text: qsTr("File name") + App.loc.emptyString
            }

            TextField {
                id: fileName
                visible: downloadTools.filesCount === 1 || downloadTools.batchDownload
                width: parent.width
                Layout.fillWidth: true
                selectByMouse: true
                inputMethodHints: Qt.ImhNoPredictiveText | Qt.ImhSensitiveData
                text: downloadTools.fileName
                onAccepted: accept()
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
        visible: downloadTools.fileSize >= 0 || !downloadTools.hasWriteAccess
        color: appWindow.theme.background
        anchors.bottom: parent.bottom
        width: parent.width
        height: 40

        BaseLabel {
            anchors.centerIn: parent
            color: !downloadTools.hasWriteAccess || downloadTools.notEnoughSpaceWarning ? appWindow.theme.errorMessage : appWindow.theme.foreground
            text: (!downloadTools.hasWriteAccess ? qsTr("No write access to the selected directory") :
                   downloadTools.freeDiskSpace != -1 ? qsTr("Size: %1 (Disk space: %2)").arg(JsTools.sizeUtils.bytesAsText(downloadTools.fileSize)).arg(JsTools.sizeUtils.bytesAsText(downloadTools.freeDiskSpace < 0 ? 0 : downloadTools.freeDiskSpace)) :
                   qsTr("Size: %1").arg(JsTools.sizeUtils.bytesAsText(downloadTools.fileSize))) + App.loc.emptyString
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
        downloadTools.getNameAndPath();
        defineFolderList();
//        if (forceDownload) {
//            downloadTools.addDownloadFromDialog();
//        }
    }

    function find(model, criteria) {
        for(var i = 0; i < model.count; ++i) if (criteria(model.get(i))) return i;
        return -1;
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
        var folderList = App.recentFolders;
        saveTo.model.clear();
        for (var i = 0; i < folderList.length; i++) {
            saveTo.model.insert(i, {'label': shortUrl(folderList[i]), 'path': folderList[i]});
        }
        updateCurrentFolder(downloadTools.filePath);
    }

    function updateCurrentFolder(folderName) {
        var index = find(saveTo.model, function(item) { return item.path == folderName });

        if (index >= 0) {
            saveTo.currentIndex = index;
         } else {
            index = saveTo.model.count;
            saveTo.model.insert(index, {'label': shortUrl(folderName), 'path': folderName});
            saveTo.currentIndex = index;
        }
    }

    function accept() {
        downloadTools.onFileNameTextChanged(fileName.displayText);
        downloadTools.onFilePathTextChanged(saveTo.model.get(saveTo.currentIndex).path);
        downloadTools.addDownloadFromDialog();
        schedulerTools.doOK();
    }

    function queryBytesAvailable() {
        if (saveTo.model.get(saveTo.currentIndex)) {
            App.storages.queryBytesAvailable(saveTo.model.get(saveTo.currentIndex).path)
            App.storages.queryIfHasWriteAccess(saveTo.model.get(saveTo.currentIndex).path);
        }
    }

    Connections {
        target: App.storages
        onBytesAvailableResult: {
            if (path == saveTo.model.get(saveTo.currentIndex).path) {
                downloadTools.freeDiskSpace = available;
            }
        }
        onHasWriteAccessResult: {
            if (path == saveTo.model.get(saveTo.currentIndex).path) {
                downloadTools.hasWriteAccess = result;
            }
        }
    }
}
