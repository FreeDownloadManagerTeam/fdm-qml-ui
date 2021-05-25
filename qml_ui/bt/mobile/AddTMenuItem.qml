import QtQuick 2.10
import org.freedownloadmanager.fdm 1.0
import "../../mobile/BaseElements"

BaseMenuItem {
    enabled: !locked
    text: App.my_BT_qsTranslate("DownloadContextMenu", "Add trackers") + App.loc.emptyString
    onTriggered: appWindow.createAddTDialog(selectedDownloadsTools.getCurrentDownloadIds())
}
