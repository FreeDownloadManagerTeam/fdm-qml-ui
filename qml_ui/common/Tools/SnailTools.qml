import QtQuick
import org.freedownloadmanager.fdm
import org.freedownloadmanager.fdm.tum

Item
{
    readonly property bool isSnail: App.settings.tum.currentMode == TrafficUsageMode.Snail

    property int __prevTum: TrafficUsageMode.High

    function updatePrevTum()
    {
        if (App.asyncLoadMgr.ready) {
            let tum = App.settings.tum.currentMode;
            if (tum != TrafficUsageMode.Snail)
                __prevTum = tum;
        }
    }

    function toggleSnailMode() {
        if (App.asyncLoadMgr.ready) {
            let tum = App.settings.tum.currentMode;
            if (tum == TrafficUsageMode.Snail)
                App.settings.tum.currentMode = __prevTum;
            else
                App.settings.tum.currentMode = TrafficUsageMode.Snail;
        }
    }

    Component.onCompleted: updatePrevTum()

    Connections {
        target: App.settings.tum
        onCurrentModeChanged: updatePrevTum()
    }

    Connections {
        target: App.asyncLoadMgr
        onReadyChanged: updatePrevTum()
    }
}
