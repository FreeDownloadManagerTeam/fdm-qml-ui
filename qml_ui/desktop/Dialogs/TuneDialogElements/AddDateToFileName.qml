import QtQuick 2.0
import org.freedownloadmanager.fdm 1.0
import "../../BaseElements"

BaseCheckBox {
    visible: downloadTools.addDateToFileName
    text: qsTr("Add dates to files names") + App.loc.emptyString
    checkBoxStyle: "gray"
}
