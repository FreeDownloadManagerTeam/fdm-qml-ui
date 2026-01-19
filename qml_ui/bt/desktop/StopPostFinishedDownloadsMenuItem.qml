import QtQuick
import org.freedownloadmanager.fdm
import "../../desktop/BaseElements"

BaseContextMenuItem {
    enabled: App.downloads.tracker.finishedHasEnabledPostFinishedTasks
    text: appWindow.btS.stopAllSeedingDownloadsUiText
    onTriggered: {
        App.downloads.mgr.stopAllDownloadsWithPostFinishedTasks();
    }
}
