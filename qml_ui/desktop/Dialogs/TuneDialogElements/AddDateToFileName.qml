import QtQuick 2.0
import org.freedownloadmanager.fdm 1.0
import org.freedownloadmanager.fdm.abstractdownloadoption 1.0
import "../../BaseElements"

BaseCheckBox {
    property bool changedByUser: false
    visible: downloadTools.addDateToFileNameEnabled
    checked: App.settings.downloadOptions.value(AbstractDownloadOption.AddDateToFileName) || false
    text: qsTr("Add dates to files names") + App.loc.emptyString
    checkBoxStyle: "gray"
    xOffset: 0
    onClicked: changedByUser = true
}
