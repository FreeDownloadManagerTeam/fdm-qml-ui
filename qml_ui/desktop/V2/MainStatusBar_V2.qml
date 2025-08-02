import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "../BaseElements/V2"
import "../../common"
import "../../qt5compat"
import org.freedownloadmanager.fdm
import org.freedownloadmanager.fdm.appsettings
import org.freedownloadmanager.fdm.dmcoresettings
import org.freedownloadmanager.fdm.tum

Item
{
    readonly property color tumColor: tumDisplayColor(App.settings.tum.currentMode)

    function tumDisplayText(tum) {
        switch (tum) {
        case TrafficUsageMode.Low: return qsTr("Low");
        case TrafficUsageMode.Medium: return qsTr("Medium");
        case TrafficUsageMode.High: return qsTr("High");
        default: return "";
        }
    }

    function tumDisplayColor(tum) {
        switch (tum) {
        case TrafficUsageMode.Low: return appWindow.theme_v2.danger;
        case TrafficUsageMode.Medium: return appWindow.theme_v2.amber;
        case TrafficUsageMode.High: return appWindow.theme_v2.secondary;
        default: return "transparent";
        }
    }

    function tumParamsDisplayText(tum) {
        if (tum == TrafficUsageMode.High)
            return qsTr("Unlimited");
        return "↑ %1 ↓ %2"
            .arg(App.speedAsText(App.settings.tum.value(tum, DmCoreSettings.MaxDownloadSpeed)))
            .arg(App.speedAsText(App.settings.tum.value(tum, DmCoreSettings.MaxUploadSpeed)))
    }

    implicitWidth: core.implicitWidth
    implicitHeight: core.implicitHeight

    Rectangle
    {
        visible: snailTools.isSnail
        anchors.fill: parent
        gradient: appWindow.theme_v2.snailOnGradient
    }

    ColumnLayout
    {
        id: core

        anchors.fill: parent

        spacing: 0

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 1*appWindow.zoom
            color: appWindow.theme_v2.bg200
        }

        Item {
            implicitWidth: 1
            implicitHeight: theme_v2.mainWindowBottomMargin*appWindow.zoom
        }

        RowLayout
        {
            Layout.leftMargin: theme_v2.mainWindowLeftMargin*appWindow.zoom
            Layout.rightMargin: theme_v2.mainWindowRightMargin*appWindow.zoom

            spacing: 0

            Item {implicitHeight: 28*appWindow.zoom; implicitWidth: 1*appWindow.zoom}

            WaSvgImage {
                id: snailBtn
                source: Qt.resolvedUrl("snail_" + (snailTools.isSnail ? "on_" : "off_") + (appWindow.theme_v2.isLightTheme ? "light" : "dark") + ".svg")
                zoom: appWindow.zoom
                MouseAreaWithHand_V2 {
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: snailTools.toggleSnailMode()
                    BaseToolTip_V2 {
                        text: qsTr("Snail mode frees bandwidth without stopping downloads.") + App.loc.emptyString
                        visible: parent.containsMouse
                    }
                }
            }

            Item {implicitWidth: 12*appWindow.zoom; implicitHeight: 1}

            BaseText_V2 {
                visible: snailTools.isSnail
                text: qsTr("Snail mode") + App.loc.emptyString
                color: appWindow.theme_v2.snailOnTextColor
                font.capitalization: Font.AllUppercase
            }

            Item {
                visible: !snailTools.isSnail

                implicitWidth: tumLayout.implicitWidth + tumLayout.x*2
                implicitHeight: Math.max(tumLayout.implicitHeight, snailBtn.implicitHeight + 2*appWindow.zoom)

                Rectangle {
                    anchors.fill: parent
                    color: App.settings.tum.currentMode != TrafficUsageMode.High ?
                               appWindow.theme_v2.opacityColor(tumColor, 0.1) :
                               "transparent"
                    border.width: 1*appWindow.zoom
                    border.color: App.settings.tum.currentMode != TrafficUsageMode.High ?
                                      tumColor :
                                      appWindow.theme_v2.bg300
                    radius: 4*appWindow.zoom
                }

                RowLayout {
                    id: tumLayout

                    anchors.verticalCenter: parent.verticalCenter
                    x: 4*appWindow.zoom

                    spacing: 0

                    Item {
                        implicitWidth: 16*appWindow.zoom
                        implicitHeight: implicitWidth
                        SvgImage_V2 {
                            imageColor: appWindow.theme_v2.bg600
                            source: Qt.resolvedUrl("arrow_drop_down.svg")
                            anchors.centerIn: parent
                        }
                    }
                    BaseText_V2 {
                        text: App.speedAsText(App.downloads.stats.totalDownloadSpeed) + App.loc.emptyString
                        color: appWindow.theme_v2.bg800
                    }

                    Item {implicitWidth: 8*appWindow.zoom; implicitHeight: 1}

                    Item {
                        implicitWidth: 16*appWindow.zoom
                        implicitHeight: implicitWidth
                        SvgImage_V2 {
                            imageColor: appWindow.theme_v2.bg600
                            source: Qt.resolvedUrl("arrow_drop_up.svg")
                            anchors.centerIn: parent
                        }
                    }
                    BaseText_V2 {
                        text: App.speedAsText(App.downloads.stats.totalUploadSpeed) + App.loc.emptyString
                        color: appWindow.theme_v2.bg800
                    }

                    Item {implicitWidth: 16*appWindow.zoom; implicitHeight: 1}

                    Item {
                        implicitWidth: tumSelector.implicitWidth
                        implicitHeight: tumSelector.implicitHeight
                        RowLayout {
                            id: tumSelector
                            anchors.fill: parent
                            spacing: 0
                            Rectangle {
                                implicitWidth: 16*appWindow.zoom
                                implicitHeight: implicitWidth
                                radius: 4*appWindow.zoom
                                color: tumColor
                                SvgImage_V2 {
                                    imageColor: appWindow.theme_v2.bgColor
                                    source: Qt.resolvedUrl("trending_up.svg")
                                    anchors.centerIn: parent
                                }
                            }
                            Item {implicitWidth: 6*appWindow.zoom; implicitHeight: 1}
                            Item {
                                implicitWidth: childrenRect.width
                                implicitHeight: 16*appWindow.zoom
                                BaseText_V2 {
                                    text: tumDisplayText(App.settings.tum.currentMode) + App.loc.emptyString
                                    font.pixelSize: 12*appWindow.fontZoom
                                    font.capitalization: Font.AllUppercase
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                            }
                            Item {implicitWidth: 4*appWindow.zoom; implicitHeight: 1}
                        }
                        MouseAreaWithHand_V2 {
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: {
                                if (!tumSelectorPopupHelper.isPopupClosedRecently())
                                    tumSelectorPopup.open();
                            }
                            BaseToolTip_V2 {
                                text: qsTr("Set the traffic usage mode") + App.loc.emptyString
                                visible: parent.containsMouse && !tumSelectorPopup.opened
                            }
                        }
                        PopupHelper {
                            id: tumSelectorPopupHelper
                            popup: tumSelectorPopup
                        }
                        Popup {
                            id: tumSelectorPopup
                            y: -height
                            background: Item {
                                RectangularGlow {
                                    visible: appWindow.theme_v2.useGlow
                                    anchors.fill: tumSelectorPopupBg
                                    color: appWindow.theme_v2.glowColor
                                    glowRadius: 0
                                    spread: 0
                                    cornerRadius: tumSelectorPopupBg.radius
                                }
                                Rectangle {
                                    id: tumSelectorPopupBg
                                    anchors.fill: parent
                                    color: appWindow.theme_v2.popupBgColor
                                    radius: 8*appWindow.zoom
                                }
                            }

                            contentItem: ColumnLayout {
                                spacing: 0
                                Repeater {
                                    model: [TrafficUsageMode.High, TrafficUsageMode.Medium, TrafficUsageMode.Low]
                                    Rectangle {
                                        Layout.preferredWidth: Math.max(tumSelectorPopupItemText.contentWidth + (12+16)*appWindow.zoom, 160*appWindow.zoom)
                                        Layout.preferredHeight: tumSelectorPopupItemText.contentHeight + 2*8*appWindow.zoom
                                        color: tumSelectorPopupItemMa.containsMouse ? appWindow.theme_v2.bg400 : "transparent"
                                        radius: 4*appWindow.zoom
                                        BaseText_V2 {
                                            id: tumSelectorPopupItemText
                                            x: 12
                                            y: 8
                                            text: tumDisplayText(modelData) +
                                                  (tumSelectorPopupItemMa.containsMouse ? " (%1)".arg(tumParamsDisplayText(modelData)) : "")
                                            color: tumDisplayColor(modelData)
                                            font.capitalization: Font.AllUppercase
                                        }
                                        MouseAreaWithHand_V2 {
                                            id: tumSelectorPopupItemMa
                                            anchors.fill: parent
                                            hoverEnabled: true
                                            onClicked: {
                                                App.settings.tum.currentMode = modelData;
                                                tumSelectorPopup.close();
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }

            RowLayout
            {
                visible: !snailTools.isSnail

                spacing: 0

                Item {implicitWidth: 48*appWindow.zoom; implicitHeight: 1}

                ElidedTextWithTooltip_V2 {
                    id: statusText
                    visible: appWindow.canShowSettingsPage() && !envTools.downloadsAutoStartPreventReasonUiText
                    color: appWindow.theme_v2.bg500
                    Layout.fillWidth: true
                    Layout.rightMargin: 8*appWindow.zoom
                    horizontalAlignment: Text.AlignRight

                    Connections {
                        target: selectedDownloadsTools
                        onCurrentDownloadIdChanged: statusText.updateText()
                        onCheckedDownloadsCountChanged: statusText.updateText()
                    }

                    Component.onCompleted: updateText()

                    function updateText()
                    {
                        if (selectedDownloadsTools.checkedDownloadsCount > 0) {
                            var ids = selectedDownloadsTools.checkedIds;
                            var total_size = 0;
                            for (var i = 0; i < ids.length; i++) {
                                total_size = total_size + App.downloads.infos.info(ids[i]).selectedBytesDownloaded;
                            }
                            statusText.sourceText = qsTr("%n downloads selected.", "", ids.length) + ' ' +
                                        qsTr("Total size:") + App.bytesAsText(total_size);

                        } else if (selectedDownloadsTools.currentDownloadId > 0) {
                            statusText.sourceText = Qt.binding(function(){return App.downloads.infos.info(selectedDownloadsTools.currentDownloadId).title.replace(/\n/g, " ");});
                        } else {
                            statusText.sourceText = "";
                        }
                    }
                }

                ElidedTextWithTooltip_V2 {
                    id: envErrText
                    sourceText: envTools.downloadsAutoStartPreventReasonUiText
                    visible: sourceText
                    color: appWindow.theme_v2.danger
                    Layout.fillWidth: true
                    Layout.rightMargin: 8*appWindow.zoom
                    horizontalAlignment: Text.AlignRight
                }

                Item {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 1
                    visible: !statusText.visible && !envErrText.visible
                }

                Item {implicitWidth: 12*appWindow.zoom; implicitHeight: 1}

                Item {
                    visible: appWindow.canShowSettingsPage() && bottomPanelTools.panelCanBeShown && bottomPanelTools.sufficientWindowHeight
                    implicitWidth: 16*appWindow.zoom
                    implicitHeight: implicitWidth
                    SvgImage_V2 {
                        source: Qt.resolvedUrl(bottomPanelTools.panelVisible ? "arrow_drop_down.svg" : "arrow_drop_up.svg")
                        anchors.centerIn: parent
                        imageColor: statusText.color
                    }
                    MouseAreaWithHand_V2 {
                        anchors.fill: parent
                        onClicked: bottomPanelTools.panelToggleClick()
                    }
                }
            }
        }

        Item {
            implicitWidth: 1
            implicitHeight: theme_v2.mainWindowBottomMargin*appWindow.zoom
        }
    }
}
