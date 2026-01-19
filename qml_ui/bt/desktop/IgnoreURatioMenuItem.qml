import QtQuick
import org.freedownloadmanager.fdm
import "../../desktop/BaseElements"

BaseContextMenuItem {
    property double downloadId: -1
    enabled: !tools.locked
    text: App.my_BT_qsTranslate("DownloadContextMenu", "Ignore upload ratio limit") + App.loc.emptyString
    checkable: true
    checked: downloadId === -1 ?
                 btTools.item.ignoreURatioLimitChecked() :
                 App.downloads.infos.info(downloadId).ignoreURatioLimit
    onTriggered: {
        if (downloadId === -1)
            btTools.item.ignoreURatioLimit(checked);
        else
            App.downloads.infos.info(downloadId).ignoreURatioLimit = checked;
    }
}
