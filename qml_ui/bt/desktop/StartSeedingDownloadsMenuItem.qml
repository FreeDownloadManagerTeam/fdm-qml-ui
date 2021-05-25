import QtQuick 2.10
import org.freedownloadmanager.fdm 1.0
import "../../desktop/BaseElements"

BaseContextMenuItem {
    enabled: App.downloads.tracker.finishedHasDisabledPostFinishedTasks
    text: appWindow.btS.startAllSeedingDownloadsUiText
    onTriggered: {
        App.downloads.mgr.startAllDownloadsWithPostFinishedTasks();
    }
}
