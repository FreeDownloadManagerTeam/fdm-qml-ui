import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import org.freedownloadmanager.fdm 1.0

import "../BaseElements"
import "../../common"

ComboBox {
    id: root

    implicitWidth: 300*appWindow.zoom
    implicitHeight: 25*appWindow.zoom
    Layout.leftMargin: 40*appWindow.zoom
    rightPadding: 5*appWindow.zoom
    leftPadding: 5*appWindow.zoom

    editable: true

    property string initialPath: ""
    property int visibleRowsCount: 5
    property int popupWidth: 120*appWindow.zoom

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

    model: ListModel {}

    delegate: Rectangle {
        property bool hover: false
        color: hover ? appWindow.theme.menuHighlight : "transparent"
        height: 18*appWindow.zoom
        width: popup.width

        BaseLabel {
            leftPadding: 6*appWindow.zoom
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: 12*appWindow.fontZoom
            color: appWindow.theme.settingsItem
            text: App.toNativeSeparators(folder)
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onEntered: parent.hover = true
            onExited: parent.hover = false
            onClicked: {
                root.currentIndex = index;
                root.editText = folder;
                root.popup.close();
            }
        }
    }

    background: Rectangle {
        color: "transparent"
        radius: 5*appWindow.zoom
        border.color: appWindow.theme.settingsControlBorder
        border.width: 1*appWindow.zoom
    }

    contentItem: BaseTextField {
        text: root.editText
        rightPadding: 30*appWindow.zoom
        font.pixelSize: 12*appWindow.fontZoom
        color: root.isCurrentPathInvalid ? appWindow.theme.errorMessage : appWindow.theme.settingsItem
        background: Rectangle {
            color: "transparent"
            border.color: "transparent"
        }
    }

    indicator: Rectangle {
        z: 1
        x: root.width - width
        y: root.topPadding + (root.availableHeight - height) / 2
        width: height - 1*appWindow.zoom
        height: root.height
        color: "transparent"
        Rectangle {
            width: 9*appWindow.zoom
            height: 8*appWindow.zoom
            color: "transparent"
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            clip: true
            WaSvgImage {
                zoom: appWindow.zoom
                source: appWindow.theme.elementsIcons
                x: 0
                y: -448*zoom
            }
        }

        MouseArea {
            propagateComposedEvents: false
            height: parent.height
            width: parent.width
            cursorShape: Qt.ArrowCursor
            onClicked: {
                if (root.popup.opened) {
                    root.popup.close();
                } else {
                    root.popup.open();
                }
            }
        }
    }

    popup: Popup {
        y: root.height
        width: Math.max(popupWidth, root.width)
        height: 18*appWindow.zoom * count + 2*appWindow.zoom
        padding: 1*appWindow.zoom

        background: Rectangle {
            color: appWindow.theme.background
            border.color: appWindow.theme.border
            border.width: 1*appWindow.zoom
        }

        contentItem: Item {
            ListView {
                clip: true
                flickableDirection: Flickable.VerticalFlick
                ScrollBar.vertical: ScrollBar{ visible: root.model.count > visibleRowsCount; policy: ScrollBar.AlwaysOn; }
                boundsBehavior: Flickable.StopAtBounds
                anchors.fill: parent
                model: root.model
                currentIndex: root.highlightedIndex
                delegate: root.delegate
            }
        }
    }

    onModelChanged: setPopupWidth()

    function setPopupWidth() {
        var maxVal = 0;
        var currentVal = 0;
        for (var index in model) {
            currentVal = checkTextSize(model.get(index).folder);
            maxVal = maxVal < currentVal ? currentVal : maxVal;
        }
        popupWidth = maxVal + 20*appWindow.zoom;
    }

    function checkTextSize(text)
    {
        textMetrics.text = text;
        return textMetrics.width;
    }

    TextMetrics {
        id: textMetrics
        font.pixelSize: 12*appWindow.fontZoom
        font.family: Qt.platform.os === "osx" ? font.family : "Arial"
    }

    Component.onCompleted: {
        var folderList = App.recentFolders;
        var currentFolder = initialPath;

        if (!folderList.length) {
            folderList = [];
            if (initialPath.length)
                folderList.push(currentFolder);
        }

        for (var i = 0; i < folderList.length; i++) {
            model.insert(i, {'folder': App.toNativeSeparators(folderList[i])});
        }

        editText = App.toNativeSeparators(currentFolder);
        setPopupWidth();

        d.isInitialized = true;
    }
}
