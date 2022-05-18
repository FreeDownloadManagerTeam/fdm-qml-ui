import QtQuick 2.11
import org.freedownloadmanager.fdm 1.0
import "./BaseElements"
import "../common/Tests"

Item {
    id: root

    height: parent.height
    implicitWidth: search_row.width

    property bool hasActiveFocus: searchText.focus

    property int maxFieldWidth: appWindow.macVersion ? (appWindow.width < 590 ? 150 : 200) : (appWindow.width < 695 ? 150 : 300)

    property int field_width: appWindow.macVersion ? maxFieldWidth : 0
    property int field_height: appWindow.macVersion ? 22 : 34
    property string border_color: appWindow.macVersion ? appWindow.theme.searchFieldBorderMac : appWindow.theme.searchFieldBorder
    property int font_size: appWindow.macVersion ? 13 : 14

    property int magnifier_width: appWindow.macVersion ? 20 : 30
    property int magnifier_x: appWindow.macVersion ? -210 : 10
    property int magnifier_y: appWindow.macVersion ? -9 : -415
    property string magnifier_img: appWindow.macVersion ? appWindow.theme.headerIconsMac : appWindow.theme.headerIcons

    property string clear_btn_img: appWindow.macVersion ? Qt.resolvedUrl("../images/desktop/search_clear_mac.svg") : Qt.resolvedUrl("../images/desktop/clean.svg")

    signal searchFieldFocusLost

    Connections {
        target: root
        onSearchFieldFocusLost: {
            searchText.focus = false;
        }
    }

    Connections {
        target: appWindow
        enabled: !appWindow.macVersion
        onWidthChanged: {
            searchMain.width = searchMain.width > 0 ? maxFieldWidth : 0;
        }
    }

    AddManyDownloads {
        id: addManyDownloads
        countDownloads: 100
    }

    Row {
        id: search_row
        visible: !pageId
        height: parent.height
        anchors.right: parent.right

        Rectangle {
            id: searchMain
            visible: width > 0
            width: root.field_width
            height: root.field_height + border.width *2
            color: appWindow.theme.searchFieldBackgound
            anchors.verticalCenter: parent.verticalCenter
            border.color: appWindow.macVersion && searchText.activeFocus ? appWindow.theme.textFieldActiveBorderMac : border_color
            border.width: appWindow.macVersion && searchText.activeFocus ? appWindow.theme.textFieldActiveBorderWidthMac : 1
            radius: appWindow.macVersion ? appWindow.theme.textFieldBorderRadiusMac : 0

            Rectangle {
                id: searchMagnifier

                anchors.left: parent.left
                anchors.leftMargin: 1
                anchors.verticalCenter: parent.verticalCenter

                width: magnifier_width - searchMain.border.width
                height: parent.height - searchMain.border.width * 2

                color: "transparent"
                clip: true

                Image {
                    x: magnifier_x
                    y: magnifier_y
                    source: magnifier_img
                    sourceSize.width: appWindow.macVersion ? 280 : 75
                    sourceSize.height: appWindow.macVersion ? 80 : 559
                }
            }

            BaseTextField {
                id: searchText
                focus: false
                visible: true
                placeholderText: qsTr("Search") + App.loc.emptyString
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: searchMagnifier.right
                anchors.right: searchClear.left
                anchors.leftMargin: searchMain.border.width
                font.pixelSize: font_size

                background: Rectangle {
                    color: "transparent"
                    border.color: "transparent"
                }

                onFocusChanged: searchMain.hideSearchFieldIfNeed()

                onAccepted: {
                    if (text === "add_many_downloads") {
                        addManyDownloads.start();
                    }
                }

                Keys.onEscapePressed: {
                    text = "";
                    focus = false;
                }

                onTextChanged: downloadsViewTools.setDownloadsTitleFilter(text)

                Connections {
                    target: downloadsViewTools
                    onDownloadsTitleFilterChanged: {
                        searchText.text = downloadsViewTools.downloadsTitleFilter;
                        searchMain.hideSearchFieldIfNeed();
                    }
                }

                MouseArea {
                    cursorShape: Qt.IBeamCursor
                    propagateComposedEvents: true
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: function (mouse) {mouse.accepted = false;}
                    onPressed: function (mouse) {mouse.accepted = false;}
                    BaseToolTip {
                        text: qsTr("Search") + App.loc.emptyString
                        visible: parent.containsMouse && !searchText.focus
                    }
                }
            }

            Rectangle {
                id: searchClear
                anchors.right: parent.right
                anchors.rightMargin: searchMain.border.width
                width: 20 - searchMain.border.width
                height: parent.height - searchMain.border.width * 2
                anchors.verticalCenter: parent.verticalCenter
                color: "transparent"

                Image {
                    visible: searchText.text.length > 0
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    width: 12
                    height: width
                    source: clear_btn_img
                    sourceSize.width: 12
                    sourceSize.height: 12

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            searchText.text = "";
                            searchText.forceActiveFocus();
                        }
                    }
                }
            }

            PropertyAnimation {
                id: searchTextShowAnimate;
                target: searchMain;
                properties: "width";
                from: 0
                to: maxFieldWidth;
                duration: 300
            }

            PropertyAnimation {
                id: searchTextHideAnimate;
                target: searchMain;
                properties: "width";
                from: maxFieldWidth
                to: 0;
                duration: 300
            }

            function hideSearchFieldIfNeed()
            {
                if (!appWindow.macVersion && !searchText.focus && searchText.text.length === 0) {
                    searchTextHideAnimate.start();
                }
            }
        }

        ToolBarButton {
            visible: !appWindow.macVersion && !searchText.visible && !pageId
            source: appWindow.theme.mainTbImg.search
            tooltipText: qsTr("Search") + App.loc.emptyString
            onClicked: startSearch()
            anchors.verticalCenter: parent.verticalCenter
        }

        ToolBarSeparator {
            visible: !appWindow.macVersion
        }
    }

    function startSearch() {
        if (!pageId) {
            if (!appWindow.macVersion && !searchText.visible) {
                searchTextShowAnimate.start();
            }
            searchText.forceActiveFocus();
        }
    }

    Shortcut {
        sequence: StandardKey.Find
        enabled: !appWindow.modalDialogOpened
        onActivated: startSearch()
    }
}
