import QtQuick
import org.freedownloadmanager.fdm
import org.freedownloadmanager.fdm.abstractdownloadoption
import "../../BaseElements"

BaseCheckBox {
    property bool changedByUser: false
    visible: downloadTools.addDateToFileNameEnabled
    checked: App.settings.downloadOptions.value(AbstractDownloadOption.AddDateToFileName) || false
    text: qsTr("Add dates to files names") + App.loc.emptyString
    checkBoxStyle: "gray"
    xOffset: 0
    onClicked: {
        changedByUser = true;

        if (!downloadTools.batchDownload) {
            App.downloads.creator.setDownloadOption(
                        downloadTools.requestId,
                        0,
                        AbstractDownloadOption.AddDateToFileName,
                        checked);
        }
    }
}
