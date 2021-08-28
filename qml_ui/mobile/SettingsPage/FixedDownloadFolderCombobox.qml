import QtQuick 2.10
import QtQuick.Controls 2.4
import QtGraphicalEffects 1.0
import org.freedownloadmanager.fdm 1.0
import org.freedownloadmanager.fdm.appsettings 1.0
import org.freedownloadmanager.fdm.dmcoresettings 1.0
import "../BaseElements"

Rectangle {
    id: root
    width: parent.width
    height: Math.max(folderBtn.height + 20, downloadFolder.implicitHeight)
    color: "transparent"

    property bool isCurrentPathValid: false

    function apply() {
        var currentPath = App.localEncodePath(
                    longUrl(downloadFolder.editText.trim()));

        root.isCurrentPathValid = App.tools.isValidAbsoluteFilePath(
                    currentPath);

        if (root.isCurrentPathValid) {
            App.settings.dmcore.setValue(
                DmCoreSettings.FixedDownloadPath, currentPath);
        }
    }

    ComboBox {
        id: downloadFolder
        enabled: root.enabled
        model: ListModel {}
        textRole: "label"
        editable: true
        implicitHeight: contentItem.implicitHeight + 10
        anchors.left: parent.left
        anchors.leftMargin: 20
        anchors.right: folderBtn.left
        anchors.rightMargin: 10
        anchors.verticalCenter: parent.verticalCenter
        font.pixelSize: 13
        onEditTextChanged: root.apply()
        delegate: Rectangle {
            height: lbl.implicitHeight + 10
            width: downloadFolder.width
            color: appWindow.theme.background
            Label {
                id: lbl
                leftPadding: 10
                rightPadding: 10
                anchors.verticalCenter: parent.verticalCenter
                text: label
                font: downloadFolder.font
                width: parent.width
                wrapMode: Text.WrapAnywhere
                color: appWindow.theme.foreground
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    downloadFolder.currentIndex = index;
                    downloadFolder.popup.close();
                    downloadFolder.editText = label;
                }
            }
        }
        contentItem: TextField {
            text: downloadFolder.currentText
            color: root.isCurrentPathValid ? appWindow.theme.foreground : appWindow.theme.errorMessage
            leftPadding: 10
            font: downloadFolder.font
            opacity: enabled ? 1 : 0.5
            selectByMouse: true
            wrapMode: Text.WrapAnywhere
            inputMethodHints: Qt.ImhNoAutoUppercase | Qt.ImhNoPredictiveText | Qt.ImhSensitiveData
        }
        background: Rectangle {
            color: appWindow.theme.background
        }
        indicator: Image {
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            source: Qt.resolvedUrl("../../images/arrow_drop_down.svg")
            sourceSize.width: 24
            sourceSize.height: 24
            opacity: enabled ? 1 : 0.5
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
        id: folderBtn
        enabled: root.enabled
        anchors.verticalCenter: parent.verticalCenter
        radius: 40
        width: 40
        height: 40
        flat: true
        onClicked: {
            var currentPath = App.localEncodePath(longUrl(downloadFolder.editText.trim()));
            stackView.waPush(filePicker.filePickerPageComponent, {folder: currentPath, initiator: "downloadsSettings", downloadId: -1, onlyFolders: true});
        }
        icon.source: Qt.resolvedUrl("../../images/download-item/folder.svg")
        icon.color: appWindow.theme.foreground
        icon.width: 18
        icon.height: 18
        opacity: enabled ? 1 : 0.5
        anchors.right: macrosBtn.left
        anchors.rightMargin: 10
    }

    Connections {
        target: filePicker
        onFolderSelected: {
            onFolderSelected: {
                console.log("[onFolderSelected] folderName", folderName);
                updateCurrentFolder(folderName);
            }
        }
    }

    DialogButton {
        id: macrosBtn
        text: qsTr("Macros") + App.loc.emptyString
        enabled: root.enabled
        radius: 40
        width: 40
        height: 40
        flat: true
        opacity: enabled ? 1 : 0.5
        anchors.right: parent.right
        anchors.rightMargin: 20
        anchors.verticalCenter: parent.verticalCenter

        onClicked: macrosMenu.open()

        MacrosMenu {
            id: macrosMenu
            onMacroSelected: {
                updateCurrentFolder(downloadFolder.editText + macro)
            }
        }
    }

    Component.onCompleted: {
        defineStorages();
        defineFolderList();
    }

    function find(model, criteria) {
        for(var i = 0; i < model.count; ++i) if (criteria(model.get(i))) return i;
        return -1;
    }

    function defineStorages() {
        for (var i = 0; i < App.storages.storagesCount(); ++i) {
            storages[i] = App.storages.storageInfo(i);
            console.log(JSON.stringify(storages[i], null, 4));
        }
    }

    function defineFolderList() {
        var folderList = App.recentFolders;
        downloadFolder.model.clear();
        for (var i = 0; i < folderList.length; i++) {
            downloadFolder.model.insert(i, {'label': shortUrl(folderList[i]), 'path': folderList[i]});
        }
        updateCurrentFolder(App.localDecodePath(App.settings.dmcore.value(DmCoreSettings.FixedDownloadPath)));
    }

    function updateCurrentFolder(folderName) {
        var index = find(downloadFolder.model, function(item) { return item.path == folderName });

        if (index >= 0) {
            downloadFolder.currentIndex = index;
         } else {
            index = downloadFolder.model.count;
            downloadFolder.model.insert(index, {'label': shortUrl(folderName), 'path': folderName});
            downloadFolder.currentIndex = index;
        }
    }

    function shortUrl(path) {
        var storage = storages.filter(function (s) { return path.startsWith(s.unrestrictedPath) });
        path = storage.length > 0 ? path.replace(storage[0].unrestrictedPath, storage[0].label) : path;
        path = path.replace(/\/$/, '');//remove last slash
        return path;
    }

    function longUrl(path) {
        var storage = storages.filter(function (s) { return path.startsWith(s.label) });
        path = storage.length > 0 ? path.replace(storage[0].label, storage[0].unrestrictedPath) : path;
        path = path.replace(/\/$/, '');//remove last slash
        return path;
    }
}
