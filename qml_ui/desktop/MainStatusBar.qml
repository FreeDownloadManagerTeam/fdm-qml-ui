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
            property int prevTum: TrafficUsageMode.High
            property bool checked: root.currentTumMode == TrafficUsageMode.Snail
            Layout.leftMargin: 5*appWindow.zoom
            Layout.alignment: Qt.AlignVCenter
            width: 32*appWindow.zoom
            height: 23*appWindow.zoom
            border.color: appWindow.theme.snailBtnBorder
            border.width: 1*appWindow.zoom
            radius: 3*appWindow.zoom

            gradient: Gradient {
                GradientStop { position: 0.0; color: snailBtn.checked ? appWindow.theme.snailBtnBackgroundStartChecked : appWindow.theme.snailBtnBackgroundStart }
                GradientStop { position: 1.0; color: snailBtn.checked ? appWindow.theme.snailBtnBackgroundEndChecked : appWindow.theme.snailBtnBackgroundEnd }
            }

            Rectangle {
                width: 23*appWindow.zoom
                height: 17*appWindow.zoom
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                color: "transparent"
                clip: true
                WaSvgImage {
                    source: appWindow.theme.elementsIcons
                    zoom: appWindow.zoom
                    x: 1*zoom
                    y: (snailBtn.checked ? -422 : -397)*zoom
                }
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                hoverEnabled: true
                onClicked: {
                    if (App.asyncLoadMgr.ready) {
                        if (App.settings.tum.currentMode == TrafficUsageMode.Snail) {
                            App.settings.tum.currentMode = snailBtn.prevTum;
                        } else {
                            snailBtn.prevTum = App.settings.tum.currentMode;
                            App.settings.tum.currentMode = TrafficUsageMode.Snail;
                        }
                    }
                }

                BaseToolTip {
                    text: qsTr("Snail mode frees bandwidth without stopping downloads.") + App.loc.emptyString
                    visible: parent.containsMouse
                }
            }
        }

        Rectangle {
            Layout.leftMargin: 5*appWindow.zoom
            color: "transparent"
            width: 50*appWindow.zoom+150*appWindow.fontZoom
            height: root.height
            TumComboBox {
                visible: root.currentTumMode != TrafficUsageMode.Snail
            }
            BaseLabel {
                visible: root.currentTumMode == TrafficUsageMode.Snail
                anchors.verticalCenter: parent.verticalCenter
                leftPadding: 5*appWindow.zoom
                text: qsTr("Snail mode") + App.loc.emptyString
            }
        }

        Item {
            height: root.height
            Layout.fillWidth: true
            Layout.leftMargin: (Qt.platform.os === "osx" ? 3 : 0)*appWindow.zoom
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
                            var ids = selectedDownloadsTools.checkedIds();
                            var total_size = 0;
                            for (var i = 0; i < ids.length; i++) {
                                total_size = total_size + App.downloads.infos.info(ids[i]).selectedBytesDownloaded;
                            }
                            var txt = qsTr("%n downloads selected.", "", ids.length);
                            txt = txt + " " + qsTr("Total size:") + " " + JsTools.sizeUtils.bytesAsText(total_size);
                            statusBarTitle.myText = txt;

                        } else if (selectedDownloadsTools.currentDownloadId > 0) {
                            statusBarTitle.myText = Qt.binding(function(){return App.downloads.infos.info(selectedDownloadsTools.currentDownloadId).title;});
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

            Rectangle {
                id: bottomPanelToggle
                visible: appWindow.canShowSettingsPage() && bottomPanelTools.panelCanBeShown && bottomPanelTools.sufficientWindowHeight
                anchors.rightMargin: 11*appWindow.zoom
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                color: "transparent"
                width: 19*appWindow.zoom
                height: 15*appWindow.zoom
                clip: true
                WaSvgImage {
                    source: appWindow.theme.elementsIcons
                    zoom: appWindow.zoom
                    x: (bottomPanelTools.panelVisible ? 3 : -37)*zoom
                    y: -22*zoom
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
