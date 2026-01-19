import QtQuick
import org.freedownloadmanager.fdm
import "../../BaseElements"

BaseCheckBox {
    text: qsTr("Scheduler") + App.loc.emptyString
    checkBoxStyle: "gray"
    checked: schedulerTools.schedulerCheckboxEnabled
    onClicked: schedulerTools.onSchedulerCheckboxChanged(checked)
}
