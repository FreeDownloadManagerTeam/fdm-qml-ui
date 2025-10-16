import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.freedownloadmanager.fdm 1.0
import org.freedownloadmanager.vmsqt 1.0
import org.freedownloadmanager.fdm.abstractdownloadsui 1.0
import "../common"
import "./BaseElements"
import "./BaseElements/V2"
import "./Dialogs"
import "V2"
import "../qt5compat"
import "Banners"

ToolBar {
    id: toolbar

    implicitHeight: meat.implicitHeight

    property string pageId

    topPadding: 0
    leftPadding: 0
    rightPadding: 0
    bottomPadding: 0

    background: Item {}

    AppDragMoveMouseArea {
        anchors.fill: parent
        z: -1
    }

    component ToolbarFlatIconButton_V2 : ToolbarFlatButton_V2 {
        bgColor: "transparent"
        leftPadding: 4*appWindow.zoom
        rightPadding: leftPadding
        topPadding: leftPadding
        bottomPadding: leftPadding
    }

    ColumnLayout {
        id: meat

        anchors.fill: parent

        opacity: appWindow.modalDialogOpened ? 0.3 : 1

        spacing: 0

        Item {
            visible: appWindow.macVersion
            Layout.fillWidth: true
            implicitHeight: 20*appWindow.zoom

            BaseText_V2 {
                text: App.displayName
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: 5*appWindow.zoom
            }
        }

        MainBannersStrip {
            id: banners
            Layout.fillWidth: true
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.leftMargin: appWindow.theme_v2.mainWindowLeftMargin*appWindow.zoom
            Layout.rightMargin: (appWindow.theme_v2.mainWindowRightMargin-4)*appWindow.zoom
            Layout.topMargin: appWindow.theme_v2.mainWindowTopMargin*appWindow.zoom
            Layout.bottomMargin: 16*appWindow.zoom
            spacing: 0

            ToolbarFlatIconButton_V2 {
                visible: toolbar.pageId
                Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                iconSource: Qt.resolvedUrl("V2/arrow_left.svg")
                iconMirror: LayoutMirroring.enabled
                onClicked: stackView.pop()
            }

            RowLayout {
                visible: !toolbar.pageId
                Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                spacing: 0
                Layout.fillWidth: true

                AllDownloadsCheckBoxButton {
                    id: allDownloadsCheckbox
                    tooltipText: qsTr("Select") + App.loc.emptyString
                    leftPadding: 12*appWindow.zoom
                }
                Item {implicitWidth: 8*appWindow.zoom; implicitHeight: 1}

                RowLayout {
                    visible: !allDownloadsCheckbox.shouldBeChecked

                    spacing: 8*appWindow.zoom

                    AllDownloadsSortModeButton {
                        tooltipText: qsTr("Sort") + App.loc.emptyString
                        rightPadding: 12*appWindow.zoom
                    }

                    AllDownloadsFilterModeButton {
                        tooltipText: qsTr("Filters") + App.loc.emptyString
                        leftPadding: 12*appWindow.zoom
                    }
                }

                RowLayout {
                    visible: allDownloadsCheckbox.shouldBeChecked

                    spacing: 8*appWindow.zoom

                    ToolbarFlatIconButton_V2 {
                        iconSource: Qt.resolvedUrl("V2/play.svg")
                        enabled: selectedDownloadsTools.checkedDownloadsToStartExist
                                 && !downloadsViewTools.emptySearchResults
                        onClicked: selectedDownloadsTools.startCheckedDownloads()
                        tooltipText: qsTr("Start") + App.loc.emptyString
                    }

                    ToolbarFlatIconButton_V2 {
                        iconSource: Qt.resolvedUrl("V2/pause.svg")
                        enabled: selectedDownloadsTools.checkedDownloadsToStopExist
                                 && !downloadsViewTools.emptySearchResults
                        onClicked: selectedDownloadsTools.stopCheckedDownloads()
                        tooltipText: qsTr("Pause") + App.loc.emptyString
                    }

                    ToolbarFlatIconButton_V2 {
                        iconSource: Qt.resolvedUrl("V2/trash.svg")
                        enabled: !downloadsViewTools.emptySearchResults
                                 && !selectedDownloadsTools.selectedDownloadsIsLocked()
                        onClicked: selectedDownloadsTools.removeCurrentDownloads()
                        tooltipText: qsTr("Remove") + App.loc.emptyString
                    }

                    ToolbarFlatIconButton_V2 {
                        visible: !App.rc.client.active
                        iconSource: Qt.resolvedUrl("V2/file_move.svg")
                        enabled: !downloadsViewTools.emptySearchResults
                                 && !selectedDownloadsTools.selectedDownloadsIsLocked()
                        onClicked: movingFolderDlg.openForIds(selectedDownloadsTools.getCurrentDownloadIds())
                        tooltipText: qsTr("Move files") + App.loc.emptyString
                    }
                }

                Item {implicitWidth: 8*appWindow.zoom; implicitHeight: 1}

                Item {
                    implicitWidth: 1
                    implicitHeight: 1
                    Layout.fillWidth: true
                }

                ToolbarFlatButton_V2 {
                    rightPadding: 12*appWindow.zoom
                    buttonType: ToolbarFlatButton_V2.PrimaryButton
                    title: qsTr("Add download") + App.loc.emptyString
                    iconSource: Qt.resolvedUrl("V2/plus_icon.svg")
                    useUppercase: false
                    Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                    onClicked: buildDownloadDlg.newDownload()
                }

                Item {implicitWidth: 16*appWindow.zoom; implicitHeight: 1}

                AllDownloadsSearchField_V2 {
                    Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                    Layout.fillWidth: true
                    Layout.minimumWidth: 40*appWindow.zoom
                    Layout.maximumWidth: implicitWidth
                    Layout.preferredWidth: implicitWidth
                }

                Item {implicitWidth: 16*appWindow.zoom; implicitHeight: 1}

                Loader {
                    id: checkUpdatesItem
                    visible: !pageId && item && item.shouldBeVisible
                    Component.onCompleted: {
                        if (appWindow.updateSupported) {
                            setSource("CheckUpdates.qml", {toolbarCtrl: toolbar})
                        }
                    }
                }

                Item {visible: checkUpdatesItem.visible; implicitWidth: 16*appWindow.zoom; implicitHeight: 1}
            }

            Item {
                visible: toolbar.pageId
                implicitWidth: 1
                implicitHeight: 1
                Layout.fillWidth: true
            }

            WaSvgImage {
                zoom: appWindow.zoom
                source: Qt.resolvedUrl("V2/main_menu_btn.svg")
                layer.effect: ColorOverlay { color: appWindow.theme_v2.bg1000 }
                layer.enabled: true
                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                Layout.margins: 4*appWindow.zoom

                MainMenu {
                    id: mainMenu
                    readonly property int maxHeight: appWindow.height - 50
                    y: implicitHeight >= maxHeight ? 3*appWindow.zoom : parent.height + 10*appWindow.zoom
                    height: Math.min(implicitHeight, maxHeight)
                    leftMargin: 8*appWindow.zoom
                    rightMargin: leftMargin
                }

                MouseAreaWithHand_V2 {
                    anchors.fill: parent
                    onClicked: mainMenu.opened ? mainMenu.close() : mainMenu.openMenu()
                    hoverEnabled: true

                    BaseToolTip_V2 {
                        text: qsTr("Menu and settings") + App.loc.emptyString
                        visible: parent.containsMouse && !mainMenu.opened
                    }
                }
            }
        }
    }

    UpdateDialogSubstrate {}

    Rectangle {
        anchors.fill: parent
        anchors.bottomMargin: 1
        visible: appWindow.macVersion && !appWindow.active && !appWindow.modalDialogOpened
        color: appWindow.theme.macToolbarOverlay
    }

    AppMessageDialog {
        id: sortByOrderRequired
        title: App.displayName
        text: qsTr("Switch to user-defined sorting of the download list?") + App.loc.emptyString
        buttons: AppMessageDialog.Ok | AppMessageDialog.Cancel
        onAccepted: sortTools.setSortByAndAsc(AbstractDownloadsUi.DownloadsSortByOrder, false)
    }
}
