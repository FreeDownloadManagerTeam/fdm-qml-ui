import QtQuick 2.11
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import org.freedownloadmanager.fdm 1.0
import org.freedownloadmanager.vmsqt 1.0
import org.freedownloadmanager.fdm.abstractdownloadsui 1.0
import "../common"
import "./BaseElements"
import "../qt5compat"

ToolBar {
    id: toolbar
    height: appWindow.mainToolbarHeight

    property string pageId

    Rectangle {
        anchors.fill: parent
        visible: !(appWindow.macVersion && appWindow.theme === lightTheme)
        color: appWindow.theme.toolbarBackground
    }

    Rectangle {
        anchors.fill: parent
        visible: appWindow.macVersion && appWindow.theme === lightTheme
    }

    AppDragMoveMouseArea {
        anchors.fill: parent
        z: -1
    }

    Item {
        anchors.fill: parent
        opacity: appWindow.modalDialogOpened ? 0.3 : 1



        Rectangle {
            width: parent.width
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            color: "transparent"

            Row {
                height: parent.height
                visible: pageId
                leftPadding: appWindow.macVersion ? 60 : -2

                ToolBarButton {
                    source: appWindow.theme.mainTbImg.arrow_left
                    anchors.verticalCenter: parent.verticalCenter
                    onClicked: stackView.pop()
                }

            }

            Row {
                anchors.verticalCenter: parent.rightCenter
                anchors.horizontalCenter: right
                leftPadding: appWindow.macVersion ? 80 : -2
                anchors.right: addBtn.left
                anchors.left: parent.left
                Rectangle {
                    id: titleBar
                    visible: appWindow.macVersion
                    width: 200//parent.width
                    height: visible ? 20 : 0
                    color: "transparent"
                    BaseLabel {
                        text: "<b>"+App.displayName+"</b>"
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.top: parent.top
                        anchors.topMargin: 5
                        font.pixelSize: 13
                        color: appWindow.theme.titleBar
                        elide: "ElideRight"
                    }
                }


            }



            ToolBarButton {
                visible: !pageId
                anchors.horizontalCenter: right
                id:addBtn
                width: 50
                height: 40
                anchors.right: selectedDownloadsTools.checkedDownloadsCount === 0 ? startBtn.left : startBtn1.left
                source: appWindow.theme.mainTbImg.plus
                onClicked: buildDownloadDlg.newDownload();
                tooltipText: qsTr("Add new download...") + App.loc.emptyString
                anchors.verticalCenter: parent.verticalCenter

                Rectangle {
                    z: -1
                    color: "#16a4fa"
                    radius: 4
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: 36
                    height: 26
                }
            }


            // start download btn +
            ToolBarButton {
                anchors.horizontalCenter: right
                id: startBtn
                width: 50
                height: 40
                anchors.right: selectedDownloadsTools.checkedDownloadsCount === 0 ? pauseBtn.left : pauseBtn1.left
                source: appWindow.theme.mainTbImg.play_all
                visible: !pageId && selectedDownloadsTools.checkedDownloadsCount === 0
                enabled: selectedDownloadsTools.downloadsToStartExist
                         && !downloadsViewTools.emptySearchResults
                onClicked: App.downloads.mgr.startAllDownloads()
                tooltipText: qsTr("Start all") + App.loc.emptyString
                anchors.verticalCenter: parent.verticalCenter
            }

            ToolBarButton {
                anchors.horizontalCenter: right
                id: startBtn1
                width: 50
                height: 40
                anchors.right: selectedDownloadsTools.checkedDownloadsCount === 0 ? pauseBtn.left : pauseBtn1.left
                source: appWindow.theme.mainTbImg.play_check
                visible: !pageId && selectedDownloadsTools.checkedDownloadsCount > 0
                enabled: selectedDownloadsTools.checkedDownloadsToStartExist
                         && !downloadsViewTools.emptySearchResults
                onClicked: selectedDownloadsTools.startCheckedDownloads()
                tooltipText: qsTr("Start selected") + App.loc.emptyString
                anchors.verticalCenter: parent.verticalCenter
            }
            // start download btn -

            // pause download btn +
            ToolBarButton {
                anchors.horizontalCenter: right
                id:pauseBtn
                width: 50
                height: 40
                anchors.right: selectedDownloadsTools.checkedDownloadsCount === 0 ? deleteBtn.left : deleteBtn1.left
                source: appWindow.theme.mainTbImg.pause_all
                visible: !pageId && selectedDownloadsTools.checkedDownloadsCount === 0
                enabled: selectedDownloadsTools.downloadsToStopExist
                         && !downloadsViewTools.emptySearchResults
                onClicked: {
                    App.downloads.mgr.stopAllDownloads(true);
                    var ids = App.downloads.tracker.runningIdsWithNoResumeSupport();
                    if (ids.length)
                        appWindow.stopDownload(ids);
                }
                tooltipText: qsTr("Pause all") + App.loc.emptyString
                anchors.verticalCenter: parent.verticalCenter
            }

            ToolBarButton {
                anchors.horizontalCenter: right
                id:pauseBtn1
                width: 50
                height: 40
                anchors.right: selectedDownloadsTools.checkedDownloadsCount === 0 ? deleteBtn.left : deleteBtn1.left
                source: appWindow.theme.mainTbImg.pause_check
                visible: !pageId && selectedDownloadsTools.checkedDownloadsCount > 0
                enabled: selectedDownloadsTools.checkedDownloadsToStopExist
                         && !downloadsViewTools.emptySearchResults
                onClicked: selectedDownloadsTools.stopCheckedDownloads()
                tooltipText: qsTr("Pause selected") + App.loc.emptyString
                anchors.verticalCenter: parent.verticalCenter
            }
            // pause download btn -

            //delete btn +
            ToolBarButton {
                anchors.horizontalCenter: right
                id:deleteBtn
                width: 50
                height: 40
                anchors.right: selectedDownloadsTools.checkedDownloadsCount > 0 ? moveBtn.left : moveBtn1.left
                source: appWindow.theme.mainTbImg.bin
                visible: !pageId && selectedDownloadsTools.checkedDownloadsCount === 0
                enabled: selectedDownloadsTools.currentDownloadId > 0
                         && !downloadsViewTools.emptySearchResults
                         && !selectedDownloadsTools.selectedDownloadsIsLocked()
                onClicked: selectedDownloadsTools.removeCurrentDownloads()
                tooltipText: qsTr("Delete selected") + App.loc.emptyString
                anchors.verticalCenter: parent.verticalCenter
            }

            ToolBarButton {
                anchors.horizontalCenter: right
                id:deleteBtn1
                anchors.right: selectedDownloadsTools.checkedDownloadsCount > 0 ? moveBtn.left : moveBtn1.left
                width: 50
                height: 40
                source: appWindow.theme.mainTbImg.bin_check
                visible: !pageId && selectedDownloadsTools.checkedDownloadsCount > 0
                enabled: !downloadsViewTools.emptySearchResults
                         && !selectedDownloadsTools.selectedDownloadsIsLocked()
                onClicked: selectedDownloadsTools.removeCurrentDownloads()
                tooltipText: qsTr("Delete selected") + App.loc.emptyString
                anchors.verticalCenter: parent.verticalCenter
            }



            ToolBarButton {
                anchors.horizontalCenter: right
                id:moveBtn
                width: 50
                height: 40
                anchors.right: uiSettingsTools.settings.enableUserDefinedOrderOfDownloads ? moveUpBtn.left : !pageId ? loader.left : searchField.left
                source: appWindow.theme.mainTbImg.folder_check
                visible: !pageId && selectedDownloadsTools.checkedDownloadsCount > 0
                enabled: !downloadsViewTools.emptySearchResults
                         && !selectedDownloadsTools.selectedDownloadsIsLocked()
                onClicked: movingFolderDlg.open()
                tooltipText: qsTr("Move to...") + App.loc.emptyString
                anchors.verticalCenter: parent.verticalCenter
            }
            //move btn -



            ToolBarButton {
                anchors.horizontalCenter: right
                id:moveBtn1
                anchors.right: uiSettingsTools.settings.enableUserDefinedOrderOfDownloads ? moveUpBtn.left : !pageId ? loader.left : searchField.left
                width: 50
                height: 40
                source: appWindow.theme.mainTbImg.folder
                visible: !pageId && selectedDownloadsTools.checkedDownloadsCount === 0
                enabled: selectedDownloadsTools.currentDownloadId > 0
                         && !downloadsViewTools.emptySearchResults
                         && !selectedDownloadsTools.selectedDownloadsIsLocked()
                onClicked: movingFolderDlg.open()
                tooltipText: qsTr("Move to...") + App.loc.emptyString
                anchors.verticalCenter: parent.verticalCenter
            }

            //move btn +
            ToolBarButton {
                anchors.horizontalCenter: right
                id:moveUpBtn
                width: 50
                height: 40
                anchors.right: uiSettingsTools.settings.enableUserDefinedOrderOfDownloads ? moveDownBtn.left : !pageId ? loader.left : searchField.left
                visible: !pageId && uiSettingsTools.settings.enableUserDefinedOrderOfDownloads
                enabled: App.downloads.model.canMoveSelectedDownloadsUp ||
                         (App.downloads.model.rowCount > 1 && sortTools.sortBy != AbstractDownloadsUi.DownloadsSortByOrder)
                source: selectedDownloadsTools.checkedDownloadsCount > 0 ?
                            appWindow.theme.mainTbImg.up/*_check*/ :
                            appWindow.theme.mainTbImg.up
                tooltipText: qsTr("Move downloads up") + App.loc.emptyString
                onClicked: {
                    if (sortTools.sortBy != AbstractDownloadsUi.DownloadsSortByOrder)
                        sortByOrderRequired.open();
                    else
                        App.downloads.model.moveSelectedDownloadsUp();
                }
                anchors.verticalCenter: parent.verticalCenter
            }

            //move btn -
            ToolBarButton {
                anchors.horizontalCenter: right
                id: moveDownBtn
                anchors.right: !pageId ? loader.left : searchField.left
                width: 50
                height: 40
                visible: !pageId && uiSettingsTools.settings.enableUserDefinedOrderOfDownloads
                enabled: App.downloads.model.canMoveSelectedDownloadsDown ||
                         (App.downloads.model.rowCount > 1 && sortTools.sortBy != AbstractDownloadsUi.DownloadsSortByOrder)
                source: selectedDownloadsTools.checkedDownloadsCount > 0 ?
                            appWindow.theme.mainTbImg.down/*_check*/ :
                            appWindow.theme.mainTbImg.down
                tooltipText: qsTr("Move downloads down") + App.loc.emptyString
                onClicked: {
                    if (sortTools.sortBy != AbstractDownloadsUi.DownloadsSortByOrder)
                        sortByOrderRequired.open();
                    else
                        App.downloads.model.moveSelectedDownloadsDown();
                }
                anchors.verticalCenter: parent.verticalCenter
            }

            Loader {
                id: loader
                z: 1
                height: parent.height
                anchors.right: searchField.left
                visible: !pageId
                Component.onCompleted: {
                    if (appWindow.updateSupported) {
                        var a = parent.mapToGlobal(parent.width, 0);
                        setSource("CheckUpdates.qml", {globalMaxX: a.x})
                    }
                }
            }

            MouseArea {
                visible: searchField.hasActiveFocus
                height: visible ? appWindow.height : 0
                width: visible ? appWindow.width : 0
                propagateComposedEvents: true
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                onPressed: function (mouse) {
                    mouse.accepted = false;
                    searchField.searchFieldFocusLost();
                }
            }

            SearchField {
                id: searchField
                anchors.right: menuBtn.left
            }

            ToolBarButton {
                id: menuBtn
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                source: appWindow.theme.mainTbImg.menu
                onClicked: menu.opened ? menu.close() : menu.openMenu()
                indicator: !uiSettingsTools.settings.menuMarkerShown
                tooltipText: menu.opened ? "" : qsTr("Main menu") + App.loc.emptyString

                MainMenu {
                    id: menu
                }
            }
        }

        //mac border
        Rectangle {
            z: -1
            anchors.bottom: parent.bottom
            width: parent.width
            height: 1
            visible: appWindow.macVersion
            color: appWindow.theme.macToolbarBorder
        }

        UpdateDialogSubstrate {}
    }

    Rectangle {
        anchors.fill: parent
        anchors.bottomMargin: 1
        visible: appWindow.macVersion && !appWindow.active && !appWindow.modalDialogOpened
        color: appWindow.theme.macToolbarOverlay
    }

    MessageDialog {
        id: sortByOrderRequired
        title: App.displayName
        text: qsTr("Switch to user-defined sorting of the download list?") + App.loc.emptyString
        buttons: buttonOk | buttonCancel
        onAccepted: sortTools.setSortByAndAsc(AbstractDownloadsUi.DownloadsSortByOrder, false)
    }
}
