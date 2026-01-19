import QtQuick
import org.freedownloadmanager.fdm
import "../../desktop/BaseElements"

BaseContextMenuItem {
    property double downloadId: -1
    enabled: !tools.locked
    text: App.my_BT_qsTranslate("DownloadContextMenu", "Add trackers") + App.loc.emptyString
    onTriggered: addTDlg.open(downloadId === -1 ?
                                  selectedDownloadsTools.getCurrentDownloadIds() :
                                  [downloadId]);
}
