import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Controls.Material 2.4
import org.freedownloadmanager.fdm 1.0
import org.freedownloadmanager.fdm.tum 1.0
import org.freedownloadmanager.fdm.dmcoresettings 1.0
import "../../BaseElements"
import "../../SettingsPage"

Dialog
{
    id: root
    modal: true
    parent: Overlay.overlay
    x: Math.round((appWindow.width - width) / 2)
    y: 48
    height: Math.min(parent.height - 60, 520)
    width: 320

    contentItem: Rectangle {
        anchors.fill: parent
        color: appWindow.theme.background

        Flickable {
            anchors.fill: parent
            flickableDirection: Flickable.VerticalFlick
            ScrollIndicator.vertical: ScrollIndicator { }
            boundsBehavior: Flickable.StopAtBounds
            contentHeight: 490
            clip: true

            Column {
                id: mainColumn
                spacing: 10
                width: parent.width
                anchors{
                    top: parent.top
                    horizontalCenter: parent.horizontalCenter
                    topMargin: 50
                }

                TumModeBlock {
                    tumMode: TrafficUsageMode.High
                }

                TumModeBlock {
                    tumMode: TrafficUsageMode.Medium
                }

                TumModeBlock {
                    tumMode: TrafficUsageMode.Low
                }

                TumModeBlock {
                    tumMode: TrafficUsageMode.Snail
                }

                Rectangle {
                    width: parent.width
                    height: 24
                    color: "transparent"

                    SettingsItem {
                        anchors.left: parent.left
                        anchors.right: undefined
                        anchors.leftMargin: 40
                        width: 265
                        description: qsTr("Change traffic limits") + App.loc.emptyString
                        textMargin: 0
                        textHeighIncrement: 10
                        textPointSize: 14
                        onClicked: {
                            root.close();
                            stackView.waPush(Qt.resolvedUrl("../../SettingsPage/TrafficLimitsSettings.qml"));
                        }
                    }
                }
            }
        }

        ModeButton {
            y: parent.y - 8
            anchors.horizontalCenter: parent.horizontalCenter
            currentTumMode: App.settings.tum.currentMode
            onClicked: root.close();
        }
    }

    function tumModeStr(tumMode)
    {
        switch (tumMode)
        {
        case TrafficUsageMode.Snail:
            return "Snail mode"//qsTr("Snail mode") + App.loc.emptyString
        case TrafficUsageMode.High:
            return "Fast mode"//qsTr("Fast mode") + App.loc.emptyString
        case TrafficUsageMode.Medium:
            return "Moderate mode"//qsTr("Moderate mode") + App.loc.emptyString
        case TrafficUsageMode.Low:
            return "Slow mode"//qsTr("Slow mode") + App.loc.emptyString
        }
        return ""
    }

    function tumModeBgColor(tumMode) {
        switch (tumMode)
        {
        case TrafficUsageMode.Snail:
            return appWindow.theme.snailMode
        case TrafficUsageMode.High:
            return appWindow.theme.highMode
        case TrafficUsageMode.Medium:
            return appWindow.theme.mediumMode
        case TrafficUsageMode.Low:
            return appWindow.theme.lowMode
        }
        return "transparent"
    }
}
