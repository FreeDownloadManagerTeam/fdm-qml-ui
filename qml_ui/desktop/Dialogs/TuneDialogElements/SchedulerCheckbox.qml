import QtQuick 2.0
import org.freedownloadmanager.fdm 1.0
import "../../BaseElements"

BaseCheckBox {
    text: qsTr("Scheduler") + App.loc.emptyString
    checkBoxStyle: "gray"
    checked: schedulerTools.schedulerCheckboxEnabled
    onClicked: schedulerTools.onSchedulerCheckboxChanged(checked)
}
