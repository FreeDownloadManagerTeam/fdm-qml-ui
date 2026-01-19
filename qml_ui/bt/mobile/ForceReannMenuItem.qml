import QtQuick
import org.freedownloadmanager.fdm
import "../../mobile/BaseElements"

BaseMenuItem {
    enabled: !locked
    text: App.my_BT_qsTranslate("DownloadContextMenu", "Force reannounce") + App.loc.emptyString
    onTriggered: btTools.item.forceReannounce()
}
