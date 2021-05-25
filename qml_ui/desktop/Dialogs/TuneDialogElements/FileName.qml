import QtQuick 2.0
import QtQuick.Layouts 1.3
import org.freedownloadmanager.fdm 1.0
import "../../BaseElements"

ColumnLayout {
    visible: downloadTools.filesCount === 1 || downloadTools.batchDownload

    //file name / create subfolder
    BaseLabel {
        Layout.topMargin: 6
        text: (downloadTools.batchDownload ? qsTr("Create subfolder") : qsTr("File name")) + App.loc.emptyString
    }

    BaseTextField {
        Layout.fillWidth: true
        text: downloadTools.fileName
        onTextChanged: downloadTools.onFileNameTextChanged(text)
        onAccepted: tuneDialog.doOK()
    }
}
