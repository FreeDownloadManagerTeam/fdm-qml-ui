import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import org.freedownloadmanager.fdm 1.0
import org.freedownloadmanager.fdm.dmcoresettings 1.0
import org.freedownloadmanager.fdm.tum 1.0
import "../common"
import "../common/Tools"

import "./BaseElements"

Rectangle {
    id: root
    width: parent.width
    height: 31*appWindow.zoom
    color: appWindow.theme.statusBar

    visible: App.asyncLoadMgr.ready

    property var currentTumMode: App.asyncLoadMgr.ready ? App.settings.tum.currentMode : false

    Rectangle {
        width: parent.width
        height: 1*appWindow.zoom
        color: appWindow.theme.border
    }

    RowLayout {
        anchors.fill: parent
        spacing: 0

        Rectangle {
            id: snailBtn
            Layout.leftMargin: qtbug.leftMargin(5*appWindow.zoom, 0)
            Layout.rightMargin: qtbug.rightMargin(5*appWindow.zoom, 0)
            Layout.alignment: Qt.AlignVCenter
            width: 32*appWindow.zoom
            height: 23*appWindow.zoom
            border.color: appWindow.theme.snailBtnBorder
            border.width: 1*appWindow.zoom
            radius: 3*appWindow.zoom

            gradient: Gradient {
                GradientStop { position: 0.0; color: snailTools.isSnail ? appWindow.theme.snailBtnBackgroundStartChecked : appWindow.theme.snailBtnBackgroundStart }
                GradientStop { position: 1.0; color: snailTools.isSnail ? appWindow.theme.snailBtnBackgroundEndChecked : appWindow.theme.snailBtnBackgroundEnd }
            }

            Item {
                width: 23*appWindow.zoom
                height: 17*appWindow.zoom
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                WaSvgImage {
                    source: appWindow.theme.elementsIconsRoot + (snailTools.isSnail ? "/snail_on.svg" : "/snail_off.svg")
                    zoom: appWindow.zoom
                    anchors.centerIn: parent
                }
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                hoverEnabled: true
                onClicked: snailTools.toggleSnailMode()

                BaseToolTip {
                    text: qsTr("Snail mode frees bandwidth without stopping downloads.") + App.loc.emptyString
                    visible: parent.containsMouse
                }
            }
        }

        Rectangle {
            Layout.leftMargin: qtbug.leftMargin(5*appWindow.zoom, 0)
            Layout.rightMargin: qtbug.rightMargin(5*appWindow.zoom, 0)
            color: "transparent"
            width: 50*appWindow.zoom+150*appWindow.fontZoom
            height: root.height
            TumComboBox {
                visible: root.currentTumMode != TrafficUsageMode.Snail
                anchors.left: parent.left
            }
            BaseLabel {
                visible: root.currentTumMode == TrafficUsageMode.Snail
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                leftPadding: qtbug.leftPadding(5*appWindow.zoom, 0)
                rightPadding: qtbug.rightPadding(5*appWindow.zoom, 0)
                text: qsTr("Snail mode") + App.loc.emptyString
            }
        }

        Item {
            height: root.height
            Layout.fillWidth: true
            Layout.leftMargin: qtbug.leftMargin((Qt.platform.os === "osx" ? 3 : 0)*appWindow.zoom, 0)
            Layout.rightMargin: qtbug.rightMargin((Qt.platform.os === "osx" ? 3 : 0)*appWindow.zoom, 0)
            clip: true

            BaseLabel {
                id: noInternet
                visible: envTools.downloadsAutoStartPreventReasonUiText != ""
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width
                elide: Text.ElideRight
                horizontalAlignment: Text.AlignRight
                color: appWindow.theme.errorMessage
                text: envTools.downloadsAutoStartPreventReasonUiText
                MouseArea {
                    enabled: parent.visible && parent.truncated
                    anchors.fill: parent
                    hoverEnabled: true
                    BaseToolTip {
                        text: noInternet.text
                        visible: parent.enabled && parent.containsMouse
                        fontSize: 11*appWindow.fontZoom
                    }
                }
            }

            BaseLabel {
                id: statusBarTitle

                property string myText: ""
                property string elidedText: fm.myElidedText(myText, width)

                visible: appWindow.canShowSettingsPage() && envTools.downloadsAutoStartPreventReasonUiText == ""
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width
                text: elidedText
                horizontalAlignment: Text.AlignRight

                MyFontMetrics
                {
                    id: fm
                    font: statusBarTitle.font
                }

                MouseArea {
                    visible: bottomPanelToggle.visible
                    height: parent.height
                    width: parent.contentWidth
                    hoverEnabled: true
                    anchors.right: parent.right
                    cursorShape: Qt.PointingHandCursor
                    onClicked: bottomPanelTools.panelToggleClick()
                    BaseToolTip {
                        text: statusBarTitle.myText
                        visible: parent.visible && parent.containsMouse && statusBarTitle.elidedText !== statusBarTitle.myText
                        fontSize: 11*appWindow.fontZoom
                    }
                }

                Connections {
                    target: selectedDownloadsTools
                    onCurrentDownloadIdChanged: updateStatusBarTitle()
                    onCheckedDownloadsCountChanged: updateStatusBarTitle()

                    function updateStatusBarTitle()
                    {
                        if (selectedDownloadsTools.checkedDownloadsCount > 0) {
                            var ids = selectedDownloadsTools.checkedIds;
                            var total_size = 0;
                            for (var i = 0; i < ids.length; i++) {
                                total_size = total_size + App.downloads.infos.info(ids[i]).selectedBytesDownloaded;
                            }
                            statusBarTitle.myText = qsTr("%n downloads selected.", "", ids.length) + ' ' +
                                        qsTr("Total size:") + App.bytesAsText(total_size);

                        } else if (selectedDownloadsTools.currentDownloadId > 0) {
                            statusBarTitle.myText = Qt.binding(function(){return App.downloads.infos.info(selectedDownloadsTools.currentDownloadId).title.replace(/\n/g, " ");});
                        } else {
                            statusBarTitle.myText = "";
                        }
                    }
                }
            }
        }

        Rectangle {
            Layout.alignment: Qt.AlignLeft
            color: "transparent"
            width: 32*appWindow.zoom
            height: 21*appWindow.zoom

            Item {
                id: bottomPanelToggle
                visible: appWindow.canShowSettingsPage() && bottomPanelTools.panelCanBeShown && bottomPanelTools.sufficientWindowHeight
                anchors.rightMargin: 11*appWindow.zoom
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                width: 19*appWindow.zoom
                height: 15*appWindow.zoom
                WaSvgImage {
                    source: appWindow.theme.elementsIconsRoot+(bottomPanelTools.panelVisible ? "/arrow_down.svg" : "/arrow_up.svg")
                    zoom: appWindow.zoom
                    anchors.centerIn: parent
                }
            }

            MouseArea {
                visible: bottomPanelToggle.visible
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: bottomPanelTools.panelToggleClick()
            }
        }
    }

    UpdateDialogSubstrate {}
}
