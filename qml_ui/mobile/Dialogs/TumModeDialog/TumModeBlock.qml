import QtQuick
import QtQuick.Controls
import org.freedownloadmanager.fdm
import org.freedownloadmanager.fdm.tum
import org.freedownloadmanager.fdm.appsettings
import org.freedownloadmanager.fdm.dmcoresettings
import "../../../common/Tools"

import "../../BaseElements"
import "../../SettingsPage"

Column {
    width: parent.width
    spacing: 5

    property int tumMode
    property int maxDownloadSpeed
    property int maxDownloadsCount

    Row {
        visible: tumMode !== TrafficUsageMode.Snail
        width: parent.width
        leftPadding: qtbug.leftPadding(10, 0)
        rightPadding: qtbug.rightPadding(10, 0)
        ModeButton {
            currentTumMode: tumMode
            selectAllowed: true
            onClicked: {
                App.settings.tum.currentMode = tumMode;
                tumModeDialog.close();
            }
        }
    }

    Row {
        width: parent.width
        leftPadding: qtbug.leftPadding(20, 0)
        rightPadding: qtbug.rightPadding(20, 0)
        topPadding: 10

        visible: tumMode !== TrafficUsageMode.Snail

        BaseLabel {
            text: qsTr("Download speed") + App.loc.emptyString
            font.pixelSize: 12
            width: 200
        }

        BaseLabel {
            text: (maxDownloadSpeed === 0 ? qsTr("Unlimited") : App.speedAsText(maxDownloadSpeed)) + App.loc.emptyString
            horizontalAlignment: Text.AlignHCenter
            font.weight: Font.DemiBold
            font.pixelSize: 12
            width: 60
        }
    }

    Rectangle {
        visible: tumMode !== TrafficUsageMode.Snail
        width: parent.width
        height: 1
        color: appWindow.theme.border//"#F4F4F4"
    }


    Row {
        visible: tumMode !== TrafficUsageMode.Snail
        width: parent.width
        leftPadding: qtbug.leftPadding(20, 0)
        rightPadding: qtbug.rightPadding(20, 0)

        BaseLabel {
            adaptive: true
            text: qsTr("Max. number of simultaneous downloads") + App.loc.emptyString
            wrapMode: Label.WordWrap
            width: 200
            font.pixelSize: 12
        }

        BaseLabel {
            adaptive: true
            text: maxDownloadsCount
            horizontalAlignment: Text.AlignHCenter
            font.weight: Font.DemiBold
            width: 60
            font.pixelSize: 12
        }
    }

    SwitchSetting {
        visible: tumMode === TrafficUsageMode.Snail
        description: qsTr("Snail mode") + App.loc.emptyString
        switchChecked: App.settings.tum.currentMode == TrafficUsageMode.Snail
        onClicked: snailTools.toggleSnailMode()
    }

    BaseLabel {
        visible: tumMode === TrafficUsageMode.Snail
        text: qsTr("Frees bandwidth without stopping downloads.") + App.loc.emptyString
        wrapMode: Label.WordWrap
        width: parent.width
        leftPadding: qtbug.leftPadding(20, 0)
        rightPadding: qtbug.rightPadding(20, 0)
        font.pixelSize: 12
    }

    Rectangle {
        width: parent.width
        height: 1
        color: appWindow.theme.border//"#F4F4F4"
    }

    Connections {
        target: appWindow
        onTumSettingsChanged: updateState()
    }

    Component.onCompleted: updateState()

    function updateState() {
        maxDownloadSpeed = App.settings.tum.value(tumMode, DmCoreSettings.MaxDownloadSpeed);
        maxDownloadsCount = App.settings.tum.value(tumMode, DmCoreSettings.MaxDownloads);
    }
}

//    Rectangle {
//        width: modeText.width + 6
//        height: modeText.height

//        Rectangle {
//            anchors.fill: parent
//            opacity: 0.3
//            color: tumModeBgColor(tumMode)
//        }

//        BaseLabel {
//            id: modeText
//            adaptive: true
//            labelSize: adaptiveTools.labelSize.mediumSize
//            anchors.horizontalCenter: parent.horizontalCenter
//            text: tumModeStr(tumMode)
//            font.weight: Font.DemiBold
//        }
//    }

//        BaseLabel {
//            adaptive: true
//            text: qsTr("Maximum number of connections") + App.loc.emptyString
//            wrapMode: Label.WordWrap
//            width: adaptiveTools.adaptiveByWidth(170, 250, 330)
//        }

//        BaseLabel {
//            adaptive: true
//            text: App.settings.tum.value(tumMode, DmCoreSettings.MaxConnections)
//        }
