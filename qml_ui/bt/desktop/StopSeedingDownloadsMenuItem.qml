import QtQuick 2.10
import org.freedownloadmanager.fdm 1.0
import "../../desktop/BaseElements"

BaseContextMenuItem {
    enabled: App.downloads.tracker.finishedHasEnabledPostFinishedTasks
    text: appWindow.btS.stopAllSeedingDownloadsUiText
    onTriggered: {
        App.downloads.mgr.stopAllDownloadsWithPostFinishedTasks();
    }
}
