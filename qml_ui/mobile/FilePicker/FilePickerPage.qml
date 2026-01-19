import QtQuick
import QtQuick.Controls
import Qt.labs.folderlistmodel
import QtQuick.Window
import QtQuick.Layouts
import QtQuick.Effects
import QtQuick.Controls.Material
import org.freedownloadmanager.fdm
import ".."
import "../BaseElements"
import "../Dialogs"

Page {
    id:picker
    signal fileSelected(string fileName)
    property bool showDirsFirst: true
    property string folder
    property string rootFolder
    property string nameFilters: !onlyFolders && initiator === 'addDownload' && App.cfg.cdOpenFileDlgNameFilters ? App.cfg.cdOpenFileDlgNameFilters : "*.*"
    property int downloadId: -1
    property string initiator
    property bool onlyFolders: true
    property int currentStorageIndex
    property string currentStorageName

    Component.onCompleted: {
        defineStorageList();
        updateFoldersBar();
    }
    onFolderChanged: updateFoldersBar()

    header: Column {
        id: toolbar
        height: 108
        width: root.width

        BaseToolBar {
            RowLayout {
                anchors.fill: parent

                ToolbarBackButton {
                    onClicked: stackView.pop()
                }

                ToolbarLabel {
                    text: (onlyFolders ? qsTr("Select folder") : qsTr("Select file")) + App.loc.emptyString
                    Layout.fillWidth: true
                    Layout.rightMargin: qtbug.rightMargin(0, onlyFolders ? 0 : 60)
                    Layout.leftMargin: qtbug.leftMargin(0, onlyFolders ? 0 : 60)
                }

                DialogButton {
                    text: qsTr("OK") + App.loc.emptyString
                    visible: onlyFolders
                    Layout.rightMargin: qtbug.rightMargin(0, 10)
                    Layout.leftMargin: qtbug.leftMargin(0, 10)
                    textColor: appWindow.theme.toolbarTextColor
                    onClicked: doOK()
                }
            }
        }

        ToolBarShadow {}

        ExtraToolBar {
            id: storageBar

            ListView {
                id: storageList
                anchors.left: parent.left
                anchors.right: sortMenuBtn.left
                height: parent.height
                model: ListModel{}
                orientation: ListView.Horizontal
                clip: true

                delegate: RadioDelegate {
                    id: control
                    text: model.label
                    checked: index == currentStorageIndex
                    spacing: 5
                    onPressed: {
                        currentStorageIndex = index;
                        resetFolder(absolutePath(model.unrestrictedPath));
                        storageList.positionViewAtIndex(index, ListView.Center);
                    }

                    contentItem: Label {
                        leftPadding: qtbug.leftPadding(control.indicator.width + control.spacing, 0)
                        rightPadding: qtbug.rightPadding(control.indicator.width + control.spacing, 0)
                        text: control.text
                        elide: Text.ElideRight
                        verticalAlignment: Text.AlignVCenter
                    }

                    indicator: Rectangle {
                        implicitWidth: 18
                        implicitHeight: 18
                        x: LayoutMirroring.enabled ? control.width - width - qtbug.getLeftPadding(control) : qtbug.getLeftPadding(control)
                        y: parent.height / 2 - height / 2
                        radius: 9
                        color: control.checked ? "#FFFFFF" : "transparent"
                        border.color: "#FFFFFF"
                        border.width: 2

                        Rectangle {
                            width: 8
                            height: 8
                            x: 5
                            y: 5
                            radius: 4
                            color: appWindow.theme.toolbarBackground
                            visible: control.checked
                        }
                    }
                }
            }

            ToolbarButton {
                id: sortMenuBtn
                anchors.right: parent.right
                anchors.rightMargin: -6
                anchors.verticalCenter: parent.verticalCenter
                icon.source: Qt.resolvedUrl("../../images/mobile/sort_menu.svg")
                onClicked: filePickerSortDialog.open()
                width: visible ? width : 16
            }
        }
    }

    FolderListModel {
        id: folderListModel
        showDirsFirst: picker.showDirsFirst
        folder: picker.folder
        nameFilters: picker.nameFilters
        showFiles: !onlyFolders
        sortField: uiSettingsTools.settings.filePickerSortField
        sortReversed: uiSettingsTools.settings.filePickerSortReversed
        rootFolder: picker.rootFolder
        showOnlyReadable: true
        onStatusChanged: {
            if (folderListModel.status == FolderListModel.Ready && folderListModel.folder.toString() !== picker.folder.toString()) {
                resetFolder(picker.folder.length > 0 ? absolutePath(picker.folder) : rootFolder);
            }
        }
    }

    Rectangle {
        color: "transparent"
        width: parent.width
        height: 44
        id: foldersBar
        property var folders: []

        Flickable {
            width: Math.min(parent.width, foldersBarRow.width)
            height: parent.height
            anchors.left: parent.left
            anchors.leftMargin: 15
            anchors.rightMargin: 10
            contentWidth: foldersBarRow.width
            clip: true
            onContentWidthChanged: contentX = Math.max(0, contentWidth - width)

            Row {
                id: foldersBarRow
                height: parent.height
                Repeater {
                    model: foldersBar.folders.length
                    Rectangle {
                        color: "transparent"
                        width: Math.round(folderText.width + toolbarArrow.width) + 6
                        height: parent.height

                        Image {
                            id: toolbarArrow
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
                            anchors.leftMargin: 3
                            source: Qt.resolvedUrl("../../images/mobile/arrow_right.svg")
                            sourceSize.width: 7
                            sourceSize.height: 8
                            mirror: LayoutMirroring.enabled
                            layer {
                                effect: MultiEffect {
                                    colorization: 1.0
                                    colorizationColor: appWindow.theme.foreground
                                }
                                enabled: true
                            }
                        }

                        BaseLabel {
                            id: folderText
                            text: foldersBar.folders[index].folderName
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: toolbarArrow.right
                            anchors.leftMargin: 3
                            font.bold: picker.folder == foldersBar.folders[index].fullPath ? true : false
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                picker.resetFolder(foldersBar.folders[index].fullPath)
                            }
                        }
                    }
                }
            }
        }
    }

    ListView {
        id: foldersList
        anchors.top: foldersBar.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: 15
        anchors.rightMargin: 5
        model: folderListModel
        delegate: fileListDelegate
        clip: true

        boundsBehavior: Flickable.StopAtBounds

        Component {
            id: fileListDelegate
            Rectangle {
                height: 40
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 15
                color: "transparent"

                Image {
                    id: folderIcon
                    height: 20
                    width: visible ? 20 : 0
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    source: Qt.resolvedUrl("../../images/mobile/folder.svg")
                    sourceSize.width: 20
                    sourceSize.height: 20
                    fillMode: Image.PreserveAspectFit
                    visible: folderListModel.isFolder(index)
                    layer {
                        effect: MultiEffect {
                            colorization: 1.0
                            colorizationColor: appWindow.theme.foreground
                        }
                        enabled: true
                    }
                }

                Rectangle {
                    anchors.left: folderIcon.right
                    anchors.right: parent.right
                    height: parent.height
                    color: "transparent"

                    Rectangle {
                        id: fileMarker
                        visible: !folderListModel.isFolder(index)
                        width: visible ? 8 : 0
                        height: 8
                        radius: 4
                        color: appWindow.theme.foreground
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                    }
                    BaseLabel {
                        leftPadding: qtbug.leftPadding(fileMarker.width + 10, 5)
                        rightPadding: qtbug.rightPadding(fileMarker.width + 10, 5)
                        width: parent.width - arrowRight.width - 20
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        text: fileName
                        elide: Label.ElideMiddle
                    }
                    Image {
                        id: arrowRight
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right: parent.right
                        anchors.leftMargin: 10
                        anchors.rightMargin: 10
                        source: Qt.resolvedUrl("../../images/mobile/arrow_right.svg")
                        sourceSize.width: 7
                        sourceSize.height: 8
                        visible: folderListModel.isFolder(index)
                        mirror: LayoutMirroring.enabled
                        layer {
                            effect: MultiEffect {
                                colorization: 1.0
                                colorizationColor: appWindow.theme.foreground
                            }
                            enabled: true
                        }
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            onItemClick(fileName)
                        }
                    }
                }
            }
        }

        footer: Rectangle {
            width: foldersList.width
            height: 100
            color: appWindow.theme.background
        }
    }

    RoundButton
    {
        id: createFolderBtn

        visible: onlyFolders && !foldersList.flicking && !foldersList.dragging
        onClicked: createFolderDialog.openDialog(App.tools.url(folderListModel.folder).toLocalFile())

        width: 58
        height: 58
        radius: Math.round(width / 2)

        padding: 0
        spacing: 0

        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.rightMargin: 20
        anchors.bottomMargin: 20

        Material.elevation: 0
        Material.background: appWindow.theme.selectModeBarAndPlusBtn
        display: AbstractButton.IconOnly

        icon.source: Qt.resolvedUrl("../../images/mobile/add_folder.svg")
        icon.width: 24
        icon.height: 24
        icon.color: "#fff"
    }

    BaseLabel {
        visible: folderListModel.status == FolderListModel.Ready && folderListModel.count == 0
        text: qsTr("Empty folder") + App.loc.emptyString
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 150
    }

    Rectangle {
        id: pageOverlay
        width: parent.width
        height: parent.height
        color: appWindow.theme.dimming
        visible: folderListModel.status == FolderListModel.Loading
        MouseArea {
            anchors.fill: parent
            propagateComposedEvents: false
        }
    }

    FilePickerSortDialog {
        id: filePickerSortDialog
    }

    CreateFolderDialog {
        id: createFolderDialog
    }

    Connections {
        target: filePicker
        onResetFolder: {
            picker.folder = folderName;
        }
    }

    function absolutePath(url) {
        return url.length > 0 ? (url[0] === "/" ? "file://" : "") + url : "file:///";
    }

    function updateFoldersBar() {
        foldersBar.folders = picker.getFoldersList();
    }

    function isFolder(fileName) {
        return folderListModel.isFolder(folderListModel.indexOf(folderListModel.folder + "/" + fileName));
    }
    function canMoveUp() {
        return folderListModel.folder.toString() !== rootFolder;
    }

    function resetFolder(folderName)
    {
        folder = folderName;
    }

    function onItemClick(fileName) {
        if (isFolder(fileName)) {
            //folder
            if (fileName === ".." && canMoveUp()) {
                folder = folderListModel.parentFolder;
            } else if (fileName !== ".") {
                folder = concatFolders(folderListModel.folder.toString(), fileName);
            }
        } else if (!onlyFolders) {
            //file
            fileName = concatFolders(folderListModel.folder.toString(), fileName);
            filePicker.fileSelected(fileName);
            stackView.pop();
        }
    }

    function doOK()
    {
        filePicker.folderSelected(App.tools.url(folderListModel.folder).toLocalFile(), downloadId, initiator);
        stackView.pop()
    }

    function getFoldersList()
    {
        setCurrentStorage();

        var folders_str = folder.toString();
        folders_str = folders_str.replace(rootFolder, '');
        var models = [];
        models.push({folderName: currentStorageName, fullPath: rootFolder});
        if (folders_str !== '') {
            var folders_arr = folders_str.split("/");
            var last_path = rootFolder;
            for (var i = 0; i < folders_arr.length; i++) {
                if (folders_arr[i] !== '') {
                    last_path = concatFolders(last_path, folders_arr[i]);
                    models.push({folderName: folders_arr[i], fullPath: last_path});
                }
            }
        }
        return models;
    }

    function concatFolders(f, n) {
        return (f[f.length-1] === "/" ? (f + n) : (f + '/' + n));
    }

    function setCurrentStorage() {
        var storage, path;
        var folder_str = absolutePath(folder);

        for (var i = 0; i < App.storages.storagesCount(); ++i) {
            storage = App.storages.storageInfo(i);
            path = absolutePath(storage.unrestrictedPath);

            if (storage.isPrimary || folder_str.startsWith(path)) {
                currentStorageIndex = i;
                currentStorageName = storage.label;
                rootFolder = path;

                if (folder_str.startsWith(path)) {
                    break;
                }
            }
        }
    }

    function defineStorageList() {
        var storage;
        storageList.model.clear();

        for (var i = 0; i < App.storages.storagesCount(); i++) {
            storage = App.storages.storageInfo(i);

            storageList.model.insert(i, {'label': storage.label, 'unrestrictedPath': storage.unrestrictedPath,
                                    'isUnrestrictedPathAppSpecific': storage.isUnrestrictedPathAppSpecific,
                                    'isPrimary': storage.isPrimary, 'isRemovable': storage.isRemovable
                                });
        }
    }
}
