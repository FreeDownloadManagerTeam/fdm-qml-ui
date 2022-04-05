import QtQuick 2.0
import QtQuick.Layouts 1.3
import org.freedownloadmanager.fdm 1.0

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
    border.width: 1
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
            height: 28
            color: appWindow.theme.bottomPanelBar
            border.color: appWindow.theme.border
            border.width: 1

            Row {
                height: parent.height
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 15
                visible: tabs.count > 1

                Repeater {
                    id: tabs
                    model: bottomPanelTools.currentTabsModel

                    Rectangle {
                        color: "transparent"
                        height: parent.height
                        width: glbl.width + 20

                        BaseLabel {
                            id: glbl
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: modelData.name
                            font.pixelSize: 13
                            color: bottomPanelTools.currentTab === modelData.id ? appWindow.theme.bottomPanelSelectedTabText : appWindow.theme.bottomPanelTabText
                        }

                        Rectangle {
                            visible: bottomPanelTools.currentTab === modelData.id
                            width: parent.width
                            height: 3
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
                width: 21
                height: 21
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.rightMargin: 4
                clip: true
                Image {
                    source: appWindow.theme.elementsIcons
                    sourceSize.width: 93
                    sourceSize.height: 456
                    x: 4
                    y: -367
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: bottomPanelTools.panelCloseClick()
                }
            }

            Rectangle {
                width: parent.width
                height: 1
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
                bottomPanelHeight: parent.height - 30
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
