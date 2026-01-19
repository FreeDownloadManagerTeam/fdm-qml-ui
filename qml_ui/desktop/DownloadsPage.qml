import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../common"
import "../common/Tools"
import "./Dialogs"
import "./Banners"
import "./BottomPanel"
import "./BaseElements"
import "./V2"
import "./BaseElements/V2"
import org.freedownloadmanager.fdm
import org.freedownloadmanager.fdm.appfeatures

Page {
    id: root

    property var keyboardFocusItem: keyboardFocusItem

    readonly property bool showDownloadsList: appWindow.emptySearchResults ||
                                              (downloadsView.item && downloadsView.item.count > 0)
    readonly property bool showDropArea: !showDownloadsList

    Component.onCompleted: {
        keyboardFocusItem.focus = true;
        root.forceActiveFocus();
    }

    Item {
        id: keyboardFocusItem
        focus: true

        DownloadsItemTools {
            id: downloadsItemTools
            itemId: selectedDownloadsTools.currentDownloadId
        }

        Keys.onDownPressed: (event) => selectedDownloadsTools.navigateToNearbyItem(1, (event.modifiers & Qt.ShiftModifier))
        Keys.onUpPressed: (event) =>  selectedDownloadsTools.navigateToNearbyItem(-1, (event.modifiers & Qt.ShiftModifier))
        Keys.onSpacePressed: App.features.hasFeature(AppFeatures.FilesQuickLook) ? selectedDownloadsTools.quickLookFile() : downloadsItemTools.changeChecked()
        Keys.onEscapePressed: selectedDownloadsTools.checkAll(false)

        Keys.onDeletePressed: selectedDownloadsTools.removeCurrentDownloads()
        Keys.onPressed: (event) => {
            if (event.key === 16777219 || event.key === Qt.Key_Back) {
                selectedDownloadsTools.removeCurrentDownloads();
            }
            else if (event.key === Qt.Key_PageUp) {
                selectedDownloadsTools.navigateToNearbyPage(-1, (event.modifiers & Qt.ShiftModifier));
            }
            else if (event.key === Qt.Key_PageDown) {
                selectedDownloadsTools.navigateToNearbyPage(1, (event.modifiers & Qt.ShiftModifier));
            }
            else if (event.key === Qt.Key_End) {
                selectedDownloadsTools.navigateToEnd((event.modifiers & Qt.ShiftModifier));
            }
            else if (event.key === Qt.Key_Home) {
                selectedDownloadsTools.navigateToHome((event.modifiers & Qt.ShiftModifier));
            }
            else if (event.key === Qt.Key_F2)
            {
                if (selectedDownloadsTools.checkRenameAllowed() &&
                        selectedDownloadsTools.currentDownloadId)
                {
                    renameDownloadFileDlg.initialize(selectedDownloadsTools.currentDownloadId, 0);
                    renameDownloadFileDlg.open();
                }
            }
        }

        Keys.onShortcutOverride: {
            // https://bugreports.qt.io/browse/QTBUG-79493
            if (Qt.platform.os == "osx")
            {
                if (event.matches(StandardKey.Paste) || event.matches(StandardKey.New))
                {
                    if (!buildDownloadDlg.opened)
                        buildDownloadDlg.newDownload();
                }
                else if (event.matches(StandardKey.SelectAll))
                {
                    selectedDownloadsTools.checkAll(true);
                }
            }
        }

        Keys.onReturnPressed: {
            if (selectedDownloadsTools.currentDownloadId > 0) {
                downloadsItemTools.doAction();
            }
        }

        Shortcut {
            sequence: StandardKey.New
            onActivated: buildDownloadDlg.newDownload()
        }

        Shortcut {
            sequence: StandardKey.Paste
            onActivated: buildDownloadDlg.newDownload()
        }

        Shortcut {
            sequence: StandardKey.SelectAll
            onActivated: selectedDownloadsTools.checkAll(true)
        }
    }

    Component {
        id: mainToolbar_v1

        MainToolbar {}
    }

    Component {
        id: mainToolbar_v2

        MainToolbar_V2 {}
    }

    header: Loader {
        sourceComponent: appWindow.uiver === 1 ? mainToolbar_v1 : mainToolbar_v2
        Component.onCompleted: appWindow.mainToolbarHeight = Qt.binding(() => height)
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        MainBannersStrip {
            id: banners
            visible: appWindow.uiver === 1 && activeBanner
            Layout.fillWidth: true
        }

        Item {
            visible: appWindow.uiver !== 1 && banners.visible
            implicitHeight: 16*appWindow.zoom
            implicitWidth: 1
        }

        Rectangle {
            id: pageContent
            color: "transparent"
            Layout.fillWidth: true
            Layout.fillHeight: true

            ColumnLayout {
                id: columnLayout
                anchors.fill: parent
                spacing: 0

                Rectangle {

                    color: "transparent"
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    //filters bar
                    Loader {
                        id: filtersBar

                        source: Qt.resolvedUrl("MainFiltersBar.qml")

                        active: appWindow.uiver === 1
                        visible: active

                        anchors.left: parent.left
                        anchors.leftMargin: 5*appWindow.zoom

                        width: parent.width
                    }

                    Rectangle {
                        anchors.fill: parent
                        anchors.margins: appWindow.uiver === 1 ? 5 : 0
                        border.color: appWindow.uiver === 1 ?
                                          (!showDownloadsList ? "transparent" : appWindow.theme.border) :
                                          "transparent"
                        border.width: 1*appWindow.zoom
                        color: "transparent"
                        anchors.topMargin: filtersBar.visible ? filtersBar.height : 0

                        DownloadPageBackground {visible: appWindow.uiver === 1}

                        //downloads list
                        Item {
                            visible: showDownloadsList
                            anchors.fill: parent

                            Component {
                                id: downloadsViewHeader_v1
                                DownloadsViewHeader {}
                            }

                            Component {
                                id: downloadsViewHeader_v2
                                DownloadsViewHeader_V2 {}
                            }

                            Loader {
                                id: downloadsViewHeader
                                width: parent.width
                                sourceComponent: appWindow.uiver === 1 ? downloadsViewHeader_v1 : downloadsViewHeader_v2
                                onLoaded: {
                                    colsWidthCalc.setSource(
                                                Qt.resolvedUrl(appWindow.uiver === 1 ? "DownloadsViewHeaderColumnsWidthCalc.qml" : "V2/DownloadsViewHeaderColumnsWidthCalc_V2.qml"),
                                                {header: downloadsViewHeader.item});
                                }
                                Loader {
                                    id: colsWidthCalc
                                    onLoaded: {
                                        downloadsView.setSource(
                                                    Qt.resolvedUrl(appWindow.uiver === 1 ? "DownloadsView.qml" : "V2/DownloadsView_V2.qml"),
                                                    {downloadsViewHeader: downloadsViewHeader.item});
                                    }
                                }
                            }

                            Rectangle {
                                z: 2
                                width: parent.width
                                anchors.top: downloadsViewHeader.bottom
                                anchors.topMargin: ((appWindow.uiver === 1 ? 0 : 8)-1)*appWindow.zoom
                                anchors.bottom: parent.bottom
                                color: "transparent"
                                clip: true

                                Loader {
                                    id: downloadsView
                                    anchors.fill: parent
                                    onLoaded: {
                                        if (appWindow.uiver === 1) {
                                            colsWidthCalc.item.downloadsViewSpeedColumnHovered = Qt.binding(function() {
                                                return downloadsView.item.speedColumnHoveredDownloadId != -1;
                                            });
                                            colsWidthCalc.item.downloadsViewSpeedColumnHoveredWidth = Qt.binding(function() {
                                                return downloadsView.item.speedColumnHoveredWidth;
                                            });
                                            colsWidthCalc.item.downloadsViewSpeedColumnNotHoveredSinceTime = Qt.binding(function() {
                                                return downloadsView.item.speedColumnNotHoveredSinceTime;
                                            });
                                            colsWidthCalc.item.downloadsViewShowingCompleteMsg = Qt.binding(function() {
                                                return downloadsView.item.showingCompleteMsg > 0;
                                            });
                                        }
                                    }
                                }
                            }
                        }

                        //drop area - empty download list
                        Rectangle {
                            visible: appWindow.uiver === 1 && showDropArea
                            anchors.fill: parent
                            color: "transparent"
                            border.color: "transparent"
                            border.width: 2*appWindow.zoom
                            clip: true

                            DottedBorder {
                                anchors.fill: parent
                                anchors.topMargin: 1*appWindow.zoom
                                anchors.bottomMargin: appWindow.macVersion ? 0 : 1*appWindow.zoom
                                anchors.leftMargin: 1*appWindow.zoom
                                anchors.rightMargin: 1*appWindow.zoom
                            }

                            ColumnLayout {
                                anchors.centerIn: parent
                                BaseLabel {
                                    Layout.alignment: Qt.AlignHCenter
                                    text: qsTr("Download list is empty.") + App.loc.emptyString
                                    color: appWindow.theme.emptyListText
                                    font.pixelSize: 32*appWindow.fontZoom
                                }
                                BaseLabel {
                                    Layout.alignment: Qt.AlignHCenter
                                    text: qsTr("Add new download URL.") + App.loc.emptyString
                                    color: appWindow.theme.emptyListText
                                    font.pixelSize: 22*appWindow.fontZoom
                                }
                            }

                            DropArea {
                                enabled: !appWindow.disableDrop
                                anchors.fill: parent
                                onDropped: {
                                    if (!drag.source)
                                        App.onDropped(drop);
                                }
                            }
                        }

                        DownloadsDropArea_V2 {
                            visible: appWindow.uiver !== 1 && showDropArea
                            anchors.fill: parent
                            anchors.leftMargin: appWindow.theme_v2.mainWindowLeftMargin*appWindow.zoom
                            anchors.rightMargin: appWindow.theme_v2.mainWindowRightMargin*appWindow.zoom
                            anchors.topMargin: 16*appWindow.zoom
                            anchors.bottomMargin: 12*appWindow.zoom
                        }

                        //empty search results
                        Rectangle {
                            anchors.fill: parent
                            anchors.leftMargin: (appWindow.uiver === 1 ? 5 : appWindow.theme_v2.mainWindowLeftMargin)*appWindow.zoom
                            anchors.rightMargin: (appWindow.uiver === 1 ? 5 : appWindow.theme_v2.mainWindowRightMargin)*appWindow.zoom
                            anchors.topMargin: (appWindow.uiver === 1 ? 5 : appWindow.theme_v2.mainWindowTopMargin)*appWindow.zoom
                            anchors.bottomMargin: (appWindow.uiver === 1 ? 5 : appWindow.theme_v2.mainWindowBottomMargin)*appWindow.zoom
                            color: "transparent"
                            visible: appWindow.emptySearchResults

                            ColumnLayout {
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.horizontalCenter: parent.horizontalCenter
                                width: parent.width
                                spacing: 15*appWindow.zoom

                                BaseLabel {
                                    Layout.alignment: Qt.AlignHCenter
                                    text: (downloadsViewTools.emptySearchResults ? qsTr("No results found for") + " \"" + limitedString(downloadsViewTools.downloadsTitleFilter) + "\"" :
                                           downloadsViewTools.emptyTagResults ? qsTr("No results tagged \"%1\" found").arg(downloadsViewTools.downloadsSelectedTag) :
                                           downloadsViewTools.emptyActiveDownloadsList ? qsTr("No active downloads") :
                                           downloadsViewTools.emptyCompleteDownloadsList ? qsTr("No completed downloads") : "") + App.loc.emptyString
                                    font.pixelSize: 24*appWindow.fontZoom
                                    font.weight: Font.Light
                                    Layout.fillWidth: true
                                    wrapMode: Text.Wrap
                                    horizontalAlignment: Text.AlignHCenter
                                    textFormat: Text.PlainText

                                    function limitedString(s) {
                                        if (s.length > 100)
                                            s = s.substring(0, 99) + "...";
                                        return s;
                                    }
                                }

                                BaseLabel {
                                    Layout.alignment: Qt.AlignHCenter
                                    text: "<a href='#'>" + qsTr("Show all") + "</a>" + App.loc.emptyString
                                    MouseArea {
                                        anchors.fill: parent
                                        cursorShape: Qt.PointingHandCursor
                                        onClicked: downloadsViewTools.resetFilters()
                                    }
                                }
                            }
                        }
                    }
                }

                Rectangle {
                    id: bottomPanelRct
                    Layout.fillWidth: true
                    width: parent.width
                    visible: bottomPanelTools.panelVisible && bottomPanelTools.sufficientWindowHeight
                    Layout.preferredHeight: bottomPanelTools.panelHeigth
                    color: "transparent"

                    Loader {
                        source: Qt.resolvedUrl(appWindow.uiver === 1 ?
                                                   "BottomPanel/BottomPanel.qml" :
                                                   "V2/BottomPanel/BottomPanel_V2.qml")
                        anchors.fill: parent
                    }
                }
            }

            Rectangle {
                width: parent.width
                color: "transparent"
                height: 100*appWindow.zoom
                y: bottomPanelRct.y - 50*appWindow.zoom
                visible: dragDropRect.movingStarted
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.SplitVCursor
                }
            }

            DragDropBottomPanel {
                id: dragDropRect
                bottomPanelRct: bottomPanelRct
            }
        }
    }

    UpdateDialogSubstrate {}
}
