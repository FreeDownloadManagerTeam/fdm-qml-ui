import QtQuick 2.10
import org.freedownloadmanager.fdm 1.0
import "../../desktop/BaseElements"

BaseContextMenuItem {
    enabled: !locked
    text: App.my_BT_qsTranslate("DownloadContextMenu", "Disable seeding") + App.loc.emptyString
    checkable: true
    checked: btTools.item.disablePostFinishedTasksChecked()
    onTriggered: btTools.item.disablePostFinishedTasks(checked)
}
