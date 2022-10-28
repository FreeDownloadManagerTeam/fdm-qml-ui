import QtQuick 2.0
import QtQuick.Layouts 1.3
import org.freedownloadmanager.fdm 1.0

import "../../common"
import "../../common/Tools"
import "../BaseElements"

Rectangle {
    anchors.fill: parent;
    anchors {
        leftMargin: 5
        rightMargin: 5
        bottomMargin: 5
    }
    border.color: appWindow.theme.border
    border.width: 1*appWindow.zoom
    color: "transparent"

    DownloadsItemTools {
        id: downloadsItemTools
        itemId: selectedDownloadsTools.currentDownloadId
        onFinishedChanged: bottomPanelTools.updateState()
        onFilesCountChanged: bottomPanelTools.updateState()
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        Rectangle {
            Layout.fillWidth: true
            height: 28*appWindow.zoom
            color: appWindow.theme.bottomPanelBar
            border.color: appWindow.theme.border
            border.width: 1*appWindow.zoom

            Row {
                height: parent.height
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 15*appWindow.zoom
                visible: tabs.count > 1

                Repeater {
                    id: tabs
                    model: bottomPanelTools.currentTabsModel

                    Rectangle {
                        color: "transparent"
                        height: parent.height
                        width: glbl.width + 20*appWindow.zoom

                        BaseLabel {
                            id: glbl
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: modelData.name
                            font.pixelSize: 13*appWindow.fontZoom
                            color: bottomPanelTools.currentTab === modelData.id ? appWindow.theme.bottomPanelSelectedTabText : appWindow.theme.bottomPanelTabText
                        }

                        Rectangle {
                            visible: bottomPanelTools.currentTab === modelData.id
                            width: parent.width
                            height: 3*appWindow.zoom
                            anchors.bottom: parent.bottom
                            color: "#16a4fa"
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: bottomPanelTools.panelTabClick(modelData.id)
                        }
                    }
                }
            }

            Rectangle {
                color: "transparent"
                width: 21*appWindow.zoom
                height: 21*appWindow.zoom
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.rightMargin: 4*appWindow.zoom
                clip: true
                WaSvgImage {
                    source: appWindow.theme.elementsIcons
                    zoom: appWindow.zoom
                    x: 4*zoom
                    y: -367*zoom
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: bottomPanelTools.panelCloseClick()
                }
            }

            Rectangle {
                width: parent.width
                height: 1*appWindow.zoom
                color: appWindow.theme.border
                anchors.bottom: parent.bottom
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "transparent"

            GeneralTab {
                visible: bottomPanelTools.currentTab === "general"
                bottomPanelHeight: parent.height - 30*appWindow.zoom
            }

            FilesTab {
                visible: bottomPanelTools.currentTab === "files"
            }

            ProgressTab {
                visible: bottomPanelTools.currentTab === "progress"
            }

            ConnectionsTab {
                visible: bottomPanelTools.currentTab === "connections"
            }
        }
    }

}
