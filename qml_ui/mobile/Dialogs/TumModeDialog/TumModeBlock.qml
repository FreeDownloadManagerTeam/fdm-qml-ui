import QtQuick 2.11
import QtQuick.Controls 2.3
import org.freedownloadmanager.fdm 1.0
import org.freedownloadmanager.fdm.tum 1.0
import org.freedownloadmanager.fdm.appsettings 1.0
import org.freedownloadmanager.fdm.dmcoresettings 1.0
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
        leftPadding: 10
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
        leftPadding: 20
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
        leftPadding: 20

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
        onClicked: {
            if (App.asyncLoadMgr.ready) {
                if (App.settings.tum.currentMode == TrafficUsageMode.Snail) {
                    App.settings.tum.currentMode = tumModeDialog.prevTum;
                } else {
                    tumModeDialog.prevTum = App.settings.tum.currentMode;
                    App.settings.tum.currentMode = TrafficUsageMode.Snail;
                }
            }
        }
    }

    BaseLabel {
        visible: tumMode === TrafficUsageMode.Snail
        text: qsTr("Frees bandwidth without stopping downloads.") + App.loc.emptyString
        wrapMode: Label.WordWrap
        width: parent.width
        leftPadding: 20//40
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
