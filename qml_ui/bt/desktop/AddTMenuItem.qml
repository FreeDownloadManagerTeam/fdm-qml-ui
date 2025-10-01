import QtQuick 2.10
import org.freedownloadmanager.fdm 1.0
import "../../desktop/BaseElements"

BaseContextMenuItem {
    property double downloadId: -1
    enabled: !tools.locked
    text: App.my_BT_qsTranslate("DownloadContextMenu", "Add trackers") + App.loc.emptyString
    onTriggered: addTDlg.open(downloadId === -1 ?
                                  selectedDownloadsTools.getCurrentDownloadIds() :
                                  [downloadId]);
}
