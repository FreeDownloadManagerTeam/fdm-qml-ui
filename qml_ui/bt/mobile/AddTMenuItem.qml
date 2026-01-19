import QtQuick
import org.freedownloadmanager.fdm
import "../../mobile/BaseElements"

BaseMenuItem {
    enabled: !locked
    text: App.my_BT_qsTranslate("DownloadContextMenu", "Add trackers") + App.loc.emptyString
    onTriggered: appWindow.createAddTDialog(selectedDownloadsTools.getCurrentDownloadIds())
}
