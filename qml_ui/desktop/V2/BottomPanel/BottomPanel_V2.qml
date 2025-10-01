import QtQuick
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import org.freedownloadmanager.fdm 1.0

import "../../../common"
import "../../../common/Tools"
import "../../BaseElements/V2"
import "../../../desktop/BottomPanel"

Item
{
    DownloadsItemTools {
        id: downloadsItemTools
        itemId: selectedDownloadsTools.currentDownloadId
        onFinishedChanged: bottomPanelTools.updateState()
        onFilesCountChanged: bottomPanelTools.updateState()
        onHasDetailsChanged: bottomPanelTools.updateState()
    }

    ColumnLayout
    {
        anchors.fill: parent
        spacing: 0

        Rectangle
        {
            Layout.fillWidth: true
            Layout.preferredHeight: tabsLayout.implicitHeight
            color: appWindow.theme_v2.bg200

            RowLayout
            {
                id: tabsLayout

                spacing: 0

                anchors.fill: parent
                anchors.leftMargin: (appWindow.theme_v2.mainWindowLeftMargin-8)*appWindow.zoom
                anchors.rightMargin: (appWindow.theme_v2.mainWindowRightMargin-8)*appWindow.zoom

                Repeater {
                    id: tabs
                    model: bottomPanelTools.currentTabsModel

                    Rectangle {
                        readonly property bool isCurrent: bottomPanelTools.currentTab === modelData.id

                        radius: 4*appWindow.zoom
                        implicitHeight: tabNameText.implicitHeight + 2*2*appWindow.zoom
                        implicitWidth: tabNameText.implicitWidth + 8*2*appWindow.zoom
                        color: isCurrent ? appWindow.theme_v2.bg600 : "transparent"
                        Layout.topMargin: 6*appWindow.zoom
                        Layout.bottomMargin: 6*appWindow.zoom

                        BaseText_V2 {
                            id: tabNameText
                            text: modelData.name
                            color: parent.isCurrent ? appWindow.theme_v2.dark1000 : appWindow.theme_v2.bg700
                            font.weight: 600
                            font.pixelSize: 10*appWindow.fontZoom
                            font.capitalization: Font.AllUppercase
                            anchors.centerIn: parent
                        }

                        MouseAreaWithHand_V2 {
                            anchors.fill: parent
                            onClicked: bottomPanelTools.panelTabClick(modelData.id)
                        }
                    }
                }

                Item {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 1
                }

                WaSvgImage {
                    zoom: appWindow.zoom
                    source: Qt.resolvedUrl("close.svg")
                    layer {
                        enabled: true
                        effect: ColorOverlay {color: appWindow.theme_v2.bg800}
                    }
                    Layout.leftMargin: 8*appWindow.zoom
                    Layout.rightMargin: 8*appWindow.zoom
                    Layout.topMargin: 7*appWindow.zoom
                    Layout.bottomMargin: 7*appWindow.zoom
                    MouseAreaWithHand_V2 {
                        anchors.fill: parent
                        onClicked: bottomPanelTools.panelCloseClick()
                    }
                }
            }
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            GeneralTab_V2 {
                visible: bottomPanelTools.currentTab === "general"
                anchors.fill: parent
            }

            DetailsTab {
                visible: bottomPanelTools.currentTab === "details"
                anchors.fill: parent
            }

            FilesTab_V2 {
                visible: bottomPanelTools.currentTab === "files"
                anchors.fill: parent
            }

            ProgressTab {
                visible: bottomPanelTools.currentTab === "progress"
                anchors.fill: parent
                anchors.leftMargin: appWindow.theme_v2.mainWindowLeftMargin*appWindow.zoom
                anchors.rightMargin: appWindow.theme_v2.mainWindowRightMargin*appWindow.zoom
                anchors.topMargin: 16*appWindow.zoom
                anchors.bottomMargin: 16*appWindow.zoom
            }

            ConnectionsTab {
                visible: bottomPanelTools.currentTab === "connections"
                anchors.fill: parent
            }
        }
    }
}
