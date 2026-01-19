import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.freedownloadmanager.fdm

import "../BaseElements"
import "../../common"

BaseComboBox {
    id: root

    comboMinimumWidth: 300*appWindow.zoom

    Layout.leftMargin: qtbug.leftMargin(40*appWindow.zoom,0)
    Layout.rightMargin: qtbug.rightMargin(40*appWindow.zoom,0)

    editable: true

    popupVisibleRowsCount: 7
    fontSize: (appWindow.uiver === 1 ? 12 : appWindow.theme_v2.fontSize)*appWindow.fontZoom
    settingsStyle: true
    textRole: ""

    property string initialPath: ""

    property string validPath: ""

    property bool waitingPathCheck: false
    readonly property bool isCurrentPathInvalid: !waitingPathCheck && editText !== validPath

    signal validPathChanged2() // is not issued on component initialization

    QtObject {
        id: d
        property bool isInitialized: false
    }

    onEditTextChanged: {
        waitingPathCheck = true;
        App.storages.isValidAbsoluteFilePath(App.fromNativeSeparators(editText));
    }

    Connections {
        target: App.storages
        onIsValidAbsoluteFilePathResult: function(path, result) {
            if (path === App.fromNativeSeparators(editText))
            {
                waitingPathCheck = false;
                if (result)
                {
                    validPath = editText;
                    validPathChanged2();
                }
            }
        }
    }

    contentItem: BaseTextField {
        text: root.editText
        topPadding: 0
        bottomPadding: 0
        leftPadding: qtbug.leftPadding(0, root.indicator.width + 4*appWindow.zoom)
        rightPadding: qtbug.rightPadding(0, root.indicator.width + 4*appWindow.zoom)
        font.pixelSize: root.fontSize
        color: root.isCurrentPathInvalid ? appWindow.theme.errorMessage : appWindow.theme.settingsItem
        background: Item {}
    }

    Component.onCompleted: {
        var folderList = App.recentFolders.list;
        var currentFolder = initialPath;

        let m = [];

        if (!folderList.length && initialPath.length)
            folderList.push(currentFolder);

        for (var i = 0; i < folderList.length; i++) {
            m.push(App.toNativeSeparators(folderList[i]));
        }

        root.model = m;

        root.currentIndex = m.indexOf(App.toNativeSeparators(currentFolder));

        editText = App.toNativeSeparators(currentFolder);

        d.isInitialized = true;
    }
}
