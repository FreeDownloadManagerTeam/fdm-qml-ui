import QtQuick 2.10
import org.freedownloadmanager.fdm 1.0
import "../../desktop/BaseElements"

BaseContextMenuItem {
    property double downloadId: -1
    readonly property var downloadInfo: downloadId === -1 ? null : App.downloads.infos.info(downloadId)
    enabled: !locked
    text: App.my_BT_qsTranslate("DownloadContextMenu", "Disable seeding") + App.loc.emptyString
    checkable: true
    checked: downloadInfo ?
                 downloadInfo.disablePostFinishedTasks || !downloadInfo.autoStartAllowed :
                 btTools.item.disablePostFinishedTasksChecked()
    onTriggered: {
        if (downloadInfo) {
            downloadInfo.disablePostFinishedTasks = checked;
            if (!checked)
                downloadInfo.autoStartAllowed = true;
        }
        else {
            btTools.item.disablePostFinishedTasks(checked);
        }
    }
}
