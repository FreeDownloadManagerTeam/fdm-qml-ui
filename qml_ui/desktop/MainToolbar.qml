import QtQuick 2.11
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import org.freedownloadmanager.fdm 1.0
import org.freedownloadmanager.vmsqt 1.0
import "../common"
import "./BaseElements"

ToolBar {
    id: toolbar
    height: appWindow.mainToolbarHeight

    property bool forSettingsPage: false

    Rectangle {
        anchors.fill: parent
        visible: !(appWindow.macVersion && appWindow.theme === lightTheme)
        color: appWindow.theme.toolbarBackground
    }

    Rectangle {
        anchors.fill: parent
        visible: appWindow.macVersion && appWindow.theme === lightTheme
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#e8e8e8" }
            GradientStop { position: 1.0; color: "#d3d3d3" }
        }
    }

    AppDragMoveMouseArea {
        anchors.fill: parent
        z: -1
    }

    Item {
        anchors.fill: parent
        opacity: appWindow.modalDialogOpened ? 0.3 : 1

        Rectangle {
            id: titleBar
            visible: appWindow.macVersion
            width: parent.width
            height: visible ? 20 : 0
            color: "transparent"

            BaseLabel {
                text: App.displayName
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: 5
                font.pixelSize: 13
                color: appWindow.theme.titleBar
            }
        }

        Rectangle {
            width: parent.width
            anchors.top: titleBar.bottom
            anchors.bottom: parent.bottom
            color: "transparent"

            Row {
                height: parent.height
                visible: forSettingsPage

                ToolBarButton {
                    backgroundPositionX: appWindow.macVersion ? -240 : 22
                    backgroundPositionY: appWindow.macVersion ? -40 : -519
                    onClicked: stackView.pop()
                }

                ToolBarSeparator {}
            }

            Row {
                height: parent.height
                visible: !forSettingsPage

                ToolBarButton {
                    width: 59
                    backgroundPositionX: appWindow.macVersion ? 1 : 19
                    backgroundPositionY: appWindow.macVersion ? 1 : 19
                    onClicked: buildDownloadDlg.newDownload();
                    color: appWindow.macVersion ? "transparent" : "#16a4fa"
                    tooltipText: qsTr("Add new download...") + App.loc.emptyString

                    Rectangle {
                        visible: appWindow.macVersion
                        z: -1
                        color: "#16a4fa"
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: 39
                        height: 39
                        radius: 20
                    }
                }

                // start download btn +
                ToolBarButton {
                    visible: selectedDownloadsTools.checkedDownloadsCount === 0
                    enabled: selectedDownloadsTools.downloadsToStartExist
                             && !downloadsViewTools.emptySearchResults
                    backgroundPositionX: appWindow.macVersion ? -40 : 22
                    backgroundPositionY: appWindow.macVersion ? 0 : -42
                    onClicked: App.downloads.mgr.startAllDownloads()
                    tooltipText: qsTr("Start all") + App.loc.emptyString
                }

                ToolBarButton {
                    visible: selectedDownloadsTools.checkedDownloadsCount > 0
                    enabled: selectedDownloadsTools.checkedDownloadsToStartExist
                             && !downloadsViewTools.emptySearchResults
                    backgroundPositionX: appWindow.macVersion ? -40 : -28
                    backgroundPositionY: appWindow.macVersion ? -40 : -43
                    onClicked: selectedDownloadsTools.startCheckedDownloads()
                    tooltipText: qsTr("Start selected") + App.loc.emptyString
                }
                // start download btn -

                ToolBarSeparator {}

                // pause download btn +
                ToolBarButton {
                    visible: selectedDownloadsTools.checkedDownloadsCount === 0
                    enabled: selectedDownloadsTools.downloadsToStopExist
                             && !downloadsViewTools.emptySearchResults
                    backgroundPositionX: appWindow.macVersion ? -80 : 23
                    backgroundPositionY: appWindow.macVersion ? 0 : -100
                    onClicked: App.downloads.mgr.stopAllDownloads()
                    tooltipText: qsTr("Pause all") + App.loc.emptyString
                }

                ToolBarButton {
                    visible: selectedDownloadsTools.checkedDownloadsCount > 0
                    enabled: selectedDownloadsTools.checkedDownloadsToStopExist
                             && !downloadsViewTools.emptySearchResults
                    backgroundPositionX: appWindow.macVersion ? -80 : -27
                    backgroundPositionY: appWindow.macVersion ? -40 : -100
                    onClicked: selectedDownloadsTools.stopCheckedDownloads()
                    tooltipText: qsTr("Pause selected") + App.loc.emptyString
                }
                // pause download btn -

                ToolBarSeparator {}

                //delete btn +
                ToolBarButton {
                    visible: selectedDownloadsTools.checkedDownloadsCount === 0
                    enabled: selectedDownloadsTools.currentDownloadId > 0
                             && !downloadsViewTools.emptySearchResults
                             && !selectedDownloadsTools.selectedDownloadsIsLocked()
                    backgroundPositionX: appWindow.macVersion ? -120 : 21
                    backgroundPositionY: appWindow.macVersion ? 0 : -160
                    onClicked: selectedDownloadsTools.removeCurrentDownloads()
                    tooltipText: qsTr("Delete selected") + App.loc.emptyString
                }

                ToolBarButton {
                    visible: selectedDownloadsTools.checkedDownloadsCount > 0
                    enabled: !downloadsViewTools.emptySearchResults
                             && !selectedDownloadsTools.selectedDownloadsIsLocked()
                    backgroundPositionX: appWindow.macVersion ? -120 : -26
                    backgroundPositionY: appWindow.macVersion ? -40 : -160
                    onClicked: selectedDownloadsTools.removeCurrentDownloads()
                    tooltipText: qsTr("Delete selected") + App.loc.emptyString
                }
                //delete btn -

                ToolBarSeparator {}

                //move btn +
                ToolBarButton {
                    visible: selectedDownloadsTools.checkedDownloadsCount === 0
                    enabled: selectedDownloadsTools.currentDownloadId > 0
                             && !downloadsViewTools.emptySearchResults
                             && !selectedDownloadsTools.selectedDownloadsIsLocked()
                    backgroundPositionX: appWindow.macVersion ? -160 : 19
                    backgroundPositionY: appWindow.macVersion ? 0 : -221
                    onClicked: movingFolderDlg.open()
                    tooltipText: qsTr("Move to...") + App.loc.emptyString
                }

                ToolBarButton {
                    visible: selectedDownloadsTools.checkedDownloadsCount > 0
                    enabled: !downloadsViewTools.emptySearchResults
                             && !selectedDownloadsTools.selectedDownloadsIsLocked()
                    backgroundPositionX: appWindow.macVersion ? -160 : -23
                    backgroundPositionY: appWindow.macVersion ? -40 : -221
                    onClicked: movingFolderDlg.open()
                    tooltipText: qsTr("Move to...") + App.loc.emptyString
                }
                //move btn -
            }

            Loader {
                z: 1
                height: parent.height
                anchors.right: searchField.left
                visible: !forSettingsPage
                Component.onCompleted: { if (appWindow.updateSupported) { source = "CheckUpdates.qml" } }
            }

            MouseArea {
                visible: searchField.hasActiveFocus
                height: visible ? appWindow.height : 0
                width: visible ? appWindow.width : 0
                propagateComposedEvents: true
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                onPressed: {
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
                backgroundPositionX: appWindow.macVersion ? -200 : 19
                backgroundPositionY: appWindow.macVersion ? -40 : -340
                opacity: enabled ? 1 : 0.3
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
}
