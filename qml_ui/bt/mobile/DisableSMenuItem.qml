import QtQuick
import org.freedownloadmanager.fdm
import "../../mobile/BaseElements"

BaseMenuItem {
    enabled: !locked
    text: App.my_BT_qsTranslate("DownloadContextMenu", "Disable seeding") + App.loc.emptyString
    checkable: true
    checked: btTools.item.disablePostFinishedTasksChecked()
    onTriggered: btTools.item.disablePostFinishedTasks(checked)
}
