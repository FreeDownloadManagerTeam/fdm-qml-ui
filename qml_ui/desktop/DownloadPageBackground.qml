import QtQuick
import QtQuick.Controls
import org.freedownloadmanager.fdm
import org.freedownloadmanager.fdm.tum
import org.freedownloadmanager.fdm.dmcoresettings

Item {
    anchors.fill: parent
    visible: appWindow.uiver === 1

    Image {
        visible: App.settings.tum.currentMode == TrafficUsageMode.Snail
        source: Qt.resolvedUrl("../images/desktop/mode_snail.svg")
        anchors.fill: parent
        anchors.margins: 50*appWindow.zoom
        fillMode: Image.PreserveAspectFit
        anchors.verticalCenter: parent.verticalCenter
        opacity: App.settings.tum.currentMode == TrafficUsageMode.Snail ? appWindow.theme.snailBackgroundOpacity : appWindow.theme.modeBackgroundOpacity
    }

    Image {
        visible: App.settings.tum.currentMode == TrafficUsageMode.Medium || App.settings.tum.currentMode == TrafficUsageMode.Low
        source: App.settings.tum.currentMode == TrafficUsageMode.Medium ? Qt.resolvedUrl("../images/desktop/mode_medium.svg") : Qt.resolvedUrl("../images/desktop/mode_low.svg")
        anchors.fill: parent
        fillMode: Image.PreserveAspectFit
        opacity: appWindow.theme.modeBackgroundOpacity
    }
}
