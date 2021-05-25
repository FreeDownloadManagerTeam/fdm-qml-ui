import QtQuick 2.10
import org.freedownloadmanager.fdm 1.0
import "../../desktop/BaseElements"

BaseContextMenuItem {
    enabled: !locked
    text: App.my_BT_qsTranslate("DownloadContextMenu", "Add trackers") + App.loc.emptyString
    onTriggered: addTDlg.open(selectedDownloadsTools.getCurrentDownloadIds());
}
