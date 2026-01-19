import QtQuick
import org.freedownloadmanager.fdm
import "../../desktop/BaseElements"

BaseContextMenuItem {
    property double downloadId: -1
    readonly property var downloadInfo: downloadId === -1 ? null : App.downloads.infos.info(downloadId)
    enabled: !tools.locked
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
