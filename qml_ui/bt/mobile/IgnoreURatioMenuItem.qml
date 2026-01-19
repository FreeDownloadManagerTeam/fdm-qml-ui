import QtQuick
import org.freedownloadmanager.fdm
import "../../mobile/BaseElements"

BaseMenuItem {
    enabled: !locked
    text: App.my_BT_qsTranslate("DownloadContextMenu", "Ignore upload ratio limit") + App.loc.emptyString
    checkable: true
    checked: btTools.item.ignoreURatioLimitChecked()
    onTriggered: btTools.item.ignoreURatioLimit(checked)
}
