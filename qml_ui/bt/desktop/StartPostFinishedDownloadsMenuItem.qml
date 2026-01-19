import QtQuick
import org.freedownloadmanager.fdm
import "../../desktop/BaseElements"

BaseContextMenuItem {
    enabled: App.downloads.tracker.finishedHasDisabledPostFinishedTasks
    text: appWindow.btS.startAllSeedingDownloadsUiText
    onTriggered: {
        App.downloads.mgr.startAllDownloadsWithPostFinishedTasks();
    }
}
