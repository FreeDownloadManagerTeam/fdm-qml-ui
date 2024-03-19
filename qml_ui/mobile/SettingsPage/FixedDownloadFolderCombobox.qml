import QtQuick 2.10
import QtQuick.Controls 2.4
import "../../qt5compat"
import org.freedownloadmanager.fdm 1.0
import org.freedownloadmanager.fdm.appsettings 1.0
import org.freedownloadmanager.fdm.dmcoresettings 1.0
import "../BaseElements"

Rectangle {
    id: root
    width: parent.width
    implicitHeight: Math.max(folderBtn.height + 20, downloadFolder.implicitHeight)
    color: "transparent"

    QtObject {
        id: d
        property string checkingPath
        property bool isCurrentPathInvalid: false
    }

    function apply() {
        var currentPath = longUrl(downloadFolder.editText.trim());
        if (!currentPath)
        {
            d.isCurrentPathInvalid = true;
            return;
        }
        App.storages.isValidAbsoluteFilePath(d.checkingPath = currentPath);
    }

    Connections {
        target: App.storages
        onIsValidAbsoluteFilePathResult: function(path, result) {
            if (path === d.checkingPath)
            {
                d.checkingPath = ""
                d.isCurrentPathInvalid = !result;
                if (result) {
                    App.settings.dmcore.setValue(
                        DmCoreSettings.FixedDownloadPath, App.localEncodePath(path));
                }
            }
        }
    }

    BaseComboBox {
        id: downloadFolder
        enabled: root.enabled
        editable: true
        implicitHeight: contentItem.implicitHeight
        anchors.left: parent.left
        anchors.leftMargin: 20
        anchors.right: folderBtn.left
        anchors.rightMargin: 10
        anchors.verticalCenter: parent.verticalCenter
        fontSize: 13
        onEditTextChanged: root.apply()
        contentItem: BaseTextField {
            text: downloadFolder.displayText
            color: (!d.isCurrentPathInvalid || d.checkingPath) ? appWindow.theme.foreground : appWindow.theme.errorMessage
            leftPadding: qtbug.leftPadding(10, 0)
            rightPadding: qtbug.rightPadding(10, 0)
            font: downloadFolder.font
            opacity: enabled ? 1 : 0.5
            selectByMouse: true
            wrapMode: Text.WrapAnywhere
            inputMethodHints: Qt.ImhNoAutoUppercase | Qt.ImhNoPredictiveText | Qt.ImhSensitiveData
            horizontalAlignment: TextField.AlignLeft
        }
        background: Rectangle {
            color: appWindow.theme.background
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
        visible: !App.rc.client.active
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
        radius: 20
        height: 40
        flat: true
        opacity: enabled ? 1 : 0.5
        anchors.right: parent.right
        anchors.rightMargin: 20
        anchors.verticalCenter: parent.verticalCenter

        onClicked: macrosMenu.open()

        MacrosMenu {
            id: macrosMenu
            onMacroSelected: (macro) => {
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
        let m = [];
        var folderList = App.recentFolders.list;
        for (var i = 0; i < folderList.length; i++) {
            m.push({'text': shortUrl(folderList[i]), 'path': folderList[i]});
        }
        downloadFolder.model = m;
        updateCurrentFolder(App.localDecodePath(App.settings.dmcore.value(DmCoreSettings.FixedDownloadPath)));
    }

    function updateCurrentFolder(folderName) {
        if (!folderName) {
            downloadFolder.currentIndex = -1;
            return;
        }
        let index = downloadFolder.model.findIndex(item => item.path == folderName);
        if (index >= 0) {
            downloadFolder.currentIndex = index;
         } else {
            let m = downloadFolder.model;
            index = m.length;
            m.push({'text': shortUrl(folderName), 'path': folderName});
            downloadFolder.model = m;
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
