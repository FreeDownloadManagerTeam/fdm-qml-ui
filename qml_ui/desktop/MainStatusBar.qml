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
    height: 31
    color: appWindow.theme.statusBar

    visible: App.ready

    property var currentTumMode: App.ready ? App.settings.tum.currentMode : false

    Rectangle {
        width: parent.width
        height: 1
        color: appWindow.theme.border
    }

    RowLayout {
        anchors.fill: parent
        spacing: 0

        Rectangle {
            id: snailBtn
            property int prevTum: TrafficUsageMode.High
            property bool checked: root.currentTumMode == TrafficUsageMode.Snail
            Layout.leftMargin: 5
            Layout.alignment: Qt.AlignVCenter
            width: 32
            height: 23
            border.color: appWindow.theme.snailBtnBorder
            border.width: 1
            radius: 3

            gradient: Gradient {
                GradientStop { position: 0.0; color: snailBtn.checked ? appWindow.theme.snailBtnBackgroundStartChecked : appWindow.theme.snailBtnBackgroundStart }
                GradientStop { position: 1.0; color: snailBtn.checked ? appWindow.theme.snailBtnBackgroundEndChecked : appWindow.theme.snailBtnBackgroundEnd }
            }

            Rectangle {
                width: 23
                height: 17
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                color: "transparent"
                clip: true
                Image {
                    source: appWindow.theme.elementsIcons
                    sourceSize.width: 93
                    sourceSize.height: 456
                    x: 1
                    y: snailBtn.checked ? -422 : -397
                }
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                hoverEnabled: true
                onClicked: {
                    if (App.ready) {
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
            Layout.leftMargin: 5
            color: "transparent"
            width: 200
            height: root.height
            TumComboBox {
                visible: root.currentTumMode != TrafficUsageMode.Snail
            }
            BaseLabel {
                visible: root.currentTumMode == TrafficUsageMode.Snail
                anchors.verticalCenter: parent.verticalCenter
                leftPadding: 5
                text: qsTr("Snail mode") + App.loc.emptyString
            }
        }

        Item {
            height: root.height
            Layout.fillWidth: true
            Layout.leftMargin: Qt.platform.os === "osx" ? 3 : 0
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
                        fontSize: 11
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
                        fontSize: 11
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
            width: 32
            height: 21

            Rectangle {
                id: bottomPanelToggle
                visible: appWindow.canShowSettingsPage() && bottomPanelTools.panelCanBeShown && bottomPanelTools.sufficientWindowHeight
                anchors.rightMargin: 11
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                color: "transparent"
                width: 19
                height: 15
                clip: true
                Image {
                    source: appWindow.theme.elementsIcons
                    sourceSize.width: 93
                    sourceSize.height: 456
                    x: bottomPanelTools.panelVisible ? 3 : -37
                    y: -22
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
