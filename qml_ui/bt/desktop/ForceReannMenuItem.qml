import QtQuick 2.10
import org.freedownloadmanager.fdm 1.0
import "../../desktop/BaseElements"

BaseContextMenuItem {
    property double downloadId: -1
    enabled: !tools.locked
    text: App.my_BT_qsTranslate("DownloadContextMenu", "Force reannounce") + App.loc.emptyString
    onTriggered: {
        if (downloadId === -1) {
            btTools.item.forceReannounce();
        }
        else {
            App.downloads.mgr.doCustomCommand(
                        [downloadId],
                        "forceReannounce",
                        undefined);
        }
    }
}
