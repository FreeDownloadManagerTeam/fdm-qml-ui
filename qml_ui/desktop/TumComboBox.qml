import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.freedownloadmanager.fdm
import org.freedownloadmanager.fdm.dmcoresettings
import org.freedownloadmanager.fdm.tum
import org.freedownloadmanager.fdm.appconstants
import "../common"
import "../common/Tools"

import "./BaseElements"


ComboBox {
    id: root

    property double totalDownloadSpeed: App.downloads.stats.totalDownloadSpeed
    property double totalUploadSpeed: App.downloads.stats.totalUploadSpeed

    property var currentTumMode: App.asyncLoadMgr.ready ? App.settings.tum.currentMode : TrafficUsageMode.High

    property string sUnlimited: qsTr("Unlimited") + App.loc.emptyString
    property string kbps: qsTr("KB/s") + App.loc.emptyString

    visible: App.asyncLoadMgr.ready && root.currentTumMode != TrafficUsageMode.Snail

    width: parent.width
    height: parent.height

    model: ListModel {}

    delegate: Rectangle {
        width: root.width
        height: (modelData.mode === TrafficUsageMode.Low ? 30 : 35)*appWindow.zoom
        color: "transparent"

        Rectangle {
            width: parent.width-2
            height: 30*appWindow.zoom
            color: "transparent"

            property bool hover: false

            Rectangle {
                visible: parent.hover
                anchors.fill: parent
                color: modelData.mode == TrafficUsageMode.High ? appWindow.theme.highMode :
                        modelData.mode == TrafficUsageMode.Medium ? appWindow.theme.mediumMode :
                        modelData.mode == TrafficUsageMode.Low ? appWindow.theme.lowMode : "transparent"
                opacity: 0.2
            }

            RowLayout {
                anchors.left: parent.left
                height: parent.height
                anchors.verticalCenter: parent.verticalCenter
                spacing: 5*appWindow.zoom

                Rectangle {
                    Layout.preferredWidth: 4*appWindow.zoom
                    Layout.fillHeight: true
                    color: modelData.mode === TrafficUsageMode.High ? appWindow.theme.highMode :
                           modelData.mode === TrafficUsageMode.Medium ? appWindow.theme.mediumMode :
                           modelData.mode === TrafficUsageMode.Low ? appWindow.theme.lowMode : "transparent"
                }

                Item {
                    Layout.alignment: Qt.AlignVCenter
                    Layout.preferredWidth: 12*appWindow.zoom
                    Layout.preferredHeight: 10*appWindow.zoom
                    WaSvgImage {
                        visible: root.currentTumMode == modelData.mode
                        source: appWindow.theme.elementsIconsRoot + "/check_mark.svg"
                        zoom: appWindow.zoom
                        anchors.centerIn: parent
                    }
                }

                BaseLabel {
                    text: modelData.text
                    Layout.alignment: Qt.AlignVCenter
                }
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                hoverEnabled: true
                onEntered: parent.hover = true
                onExited: parent.hover = false
                onClicked: {
                    App.settings.tum.currentMode = modelData.mode;
                    root.popup.close()
                }
                BaseToolTip {
                    property string downSpeed: modelData.downloadSpeed != sUnlimited ? modelData.downloadSpeed + " " + kbps : qsTr("unlimited") + App.loc.emptyString
                    property string upSpeed: modelData.uploadSpeed != sUnlimited ? modelData.uploadSpeed + " " + kbps : qsTr("unlimited") + App.loc.emptyString
                    text: qsTr("Download: %1, Upload: %2").arg(downSpeed).arg(upSpeed) + App.loc.emptyString
                    visible: parent.containsMouse
                    fontSize: 11*appWindow.fontZoom
                }
            }
        }
    }

    indicator: Item {
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: 8*appWindow.zoom
        width: 15*appWindow.zoom
        height: 15*appWindow.zoom
        WaSvgImage {
            source: appWindow.theme.elementsIconsRoot+(root.popup.opened ? "/arrow_down.svg" : "/arrow_up.svg")
            zoom: appWindow.zoom
            anchors.centerIn: parent
        }
    }

    background: Rectangle {
        color: "transparent"

        Rectangle {
            anchors.fill: parent
            color: root.currentTumMode == TrafficUsageMode.High ? appWindow.theme.highMode :
                    root.currentTumMode == TrafficUsageMode.Medium ? appWindow.theme.mediumMode :
                    root.currentTumMode == TrafficUsageMode.Low ? appWindow.theme.lowMode : "transparent"
            opacity: 0.2
        }

        Rectangle {
            height: 3*appWindow.zoom
            width: parent.width
            anchors.bottom: parent.bottom
            color: root.currentTumMode == TrafficUsageMode.High ? appWindow.theme.highMode :
                    root.currentTumMode == TrafficUsageMode.Medium ? appWindow.theme.mediumMode :
                    root.currentTumMode == TrafficUsageMode.Low ? appWindow.theme.lowMode : "transparent"
        }

        Rectangle {
            width: parent.width
            height: 1*appWindow.zoom
            color: appWindow.theme.border
        }

        Rectangle {
            width: 1*appWindow.zoom
            height: parent.height
            color: appWindow.theme.border
            anchors.left: parent.left
        }

        Rectangle {
            width: 1*appWindow.zoom
            height: parent.height
            color: appWindow.theme.border
            anchors.right: parent.right
        }
    }

    contentItem: Rectangle {
        color: "transparent"
        height: root.height
        width: root.width

        Row {
            anchors.fill: parent
            Rectangle {
                color: "transparent"
                width: 15*appWindow.zoom+72*appWindow.fontZoom
                height: parent.height

                WaSvgImage {
                    source: appWindow.theme.arrowDownSbarImg
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 8*appWindow.zoom
                    zoom: appWindow.zoom
                }

                BaseLabel {
                    leftPadding: qtbug.leftPadding(20*appWindow.zoom, 0)
                    rightPadding: qtbug.rightPadding(20*appWindow.zoom, 0)
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    text: App.speedAsText(root.totalDownloadSpeed) + App.loc.emptyString
                }
            }
            Rectangle {
                color: "transparent"
                width: 15*appWindow.zoom+72*appWindow.fontZoom
                height: parent.height

                WaSvgImage {
                    source: appWindow.theme.arrowUpSbarImg
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 8*appWindow.zoom
                    zoom: appWindow.zoom
                }

                BaseLabel {
                    leftPadding: qtbug.leftPadding(20*appWindow.zoom, 0)
                    rightPadding: qtbug.rightPadding(20*appWindow.zoom, 0)
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    text: App.speedAsText(root.totalUploadSpeed) + App.loc.emptyString
                }
            }
        }
    }

    popup: Popup {
        id: someUnusedId // https://bugreports.qt.io/browse/QTBUG-96351

        y: 1 - height
        width: root.width
        height: 102*appWindow.zoom
        padding: 1*appWindow.zoom

        background: Rectangle {
            color: appWindow.theme.background
            border.color: appWindow.theme.border
            border.width: 1*appWindow.zoom
        }

        contentItem: Item {
            ListView {
                clip: true
                anchors.fill: parent
                model: root.model
                currentIndex: root.highlightedIndex
                delegate: root.delegate
            }
        }
    }

    Component.onCompleted: {
        updateModel()
        applyCurrentModeToCombo()
    }
    Connections {
        target: App.settings.tum
        onCurrentModeChanged: root.applyCurrentModeToCombo()
    }

    Connections {
        target: appWindow
        onTumSettingsChanged: root.updateModel()//root.reloadModel()
    }

    Connections {
        target: App.loc
        onCurrentTranslationChanged: root.updateModel();
    }

    function updateModel() {
        root.model = [
            {text: qsTr("High") + App.loc.emptyString, mode: TrafficUsageMode.High, downloadSpeed: getDownloadSpeed(TrafficUsageMode.High), uploadSpeed: getUploadSpeed(TrafficUsageMode.High)},
            {text: qsTr("Medium") + App.loc.emptyString, mode: TrafficUsageMode.Medium, downloadSpeed: getDownloadSpeed(TrafficUsageMode.Medium), uploadSpeed: getUploadSpeed(TrafficUsageMode.Medium)},
            {text: qsTr("Low") + App.loc.emptyString, mode: TrafficUsageMode.Low, downloadSpeed: getDownloadSpeed(TrafficUsageMode.Low), uploadSpeed: getUploadSpeed(TrafficUsageMode.Low)}];
    }

//    function reloadModel() {
//        var m = root.model;
//        for (var i = 0; i < m.length; i++) {
//            m[i].downloadSpeed = getDownloadSpeed(m[i].mode);
//            m[i].uploadSpeed = getUploadSpeed(m[i].mode);
//        }
//        root.model = m;
//    }

    function getDownloadSpeed(mode) {
        return getSpeed(mode, DmCoreSettings.MaxDownloadSpeed);
    }

    function getUploadSpeed(mode) {
        return getSpeed(mode, DmCoreSettings.MaxUploadSpeed);
    }

    function getSpeed(mode, setting) {
        var val = App.settings.tum.value(mode, setting);
        var text = val && val !== '0' ?
                    (parseInt(val / AppConstants.BytesInKB)).toString() :
                    sUnlimited;
        return text;
    }

    function applyCurrentModeToCombo()
    {
        var cm = root.currentTumMode;
        for (var i = 0; i < model.length; i++) {
            if (model[i].mode == cm) {
                currentIndex = i;
                return;
            }
        }
        console.assert(cm == TrafficUsageMode.Snail, "Invalid current tum");
    }
}
