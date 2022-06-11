import QtQuick 2.11
import QtQuick.Controls 2.3
import org.freedownloadmanager.fdm 1.0
import org.freedownloadmanager.fdm.tum 1.0
import org.freedownloadmanager.fdm.dmcoresettings 1.0

Item {
    anchors.fill: parent

    Image {
        visible: App.settings.tum.currentMode == TrafficUsageMode.Snail// || App.settings.tum.currentMode == TrafficUsageMode.High
        source: App.settings.tum.currentMode == TrafficUsageMode.Snail ? Qt.resolvedUrl("../images/desktop/mode_snail.svg") : Qt.resolvedUrl("../images/desktop/mode_high.svg")
        anchors.fill: parent
        anchors.margins: 50
        fillMode: Image.PreserveAspectFit
        anchors.verticalCenter: parent.verticalCenter
        opacity: App.settings.tum.currentMode == TrafficUsageMode.Snail ? appWindow.theme.snailBackgroundOpacity : appWindow.theme.modeBackgroundOpacity
    }

    Image {
        visible: App.settings.tum.currentMode == TrafficUsageMode.Medium || App.settings.tum.currentMode == TrafficUsageMode.Low
        source: App.settings.tum.currentMode == TrafficUsageMode.Medium ? Qt.resolvedUrl("../images/desktop/mode_medium.svg") : Qt.resolvedUrl("../images/desktop/mode_low.svg")
        width: parent.width
        height: width
        fillMode: Image.PreserveAspectFit
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        opacity: appWindow.theme.modeBackgroundOpacity
    }
}
