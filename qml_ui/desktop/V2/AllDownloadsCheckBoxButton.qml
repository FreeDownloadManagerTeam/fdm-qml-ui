import QtQuick
import "../BaseElements/V2"
import org.freedownloadmanager.fdm
import org.freedownloadmanager.fdm.abstractdownloadsui 

ToolbarFlatButton_V2
{
    readonly property bool shouldBeChecked: App.downloads.model.allCheckState == Qt.Checked ||
                                            App.downloads.model.allCheckState == Qt.PartiallyChecked

    hasCheckBox: true
    checked: shouldBeChecked

    dropDownMenu: BaseMenu_V2
    {
        BaseMenuItem_V2 {
            text: qsTr("All") + App.loc.emptyString
            onClicked: App.downloads.model.checkAll(true)
        }
        BaseMenuItem_V2 {
            text: qsTr("Downloads only") + App.loc.emptyString
            onClicked: App.downloads.model.checkSome(AbstractDownloadsUi.FilterDownloading, true, true)
        }
        BaseMenuItem_V2 {
            text: qsTr("Uploads only") + App.loc.emptyString
            onClicked: App.downloads.model.checkSome(AbstractDownloadsUi.FilterUploading, true, true)
        }
        BaseMenuItem_V2 {
            text: qsTr("Completed") + App.loc.emptyString
            onClicked: App.downloads.model.checkSome(AbstractDownloadsUi.FilterFinished, true, true)
        }
        BaseMenuItem_V2 {
            text: qsTr("Stopped") + App.loc.emptyString
            onClicked: App.downloads.model.checkSome(AbstractDownloadsUi.FilterStopped, true, true)
        }
    }

    onCheckBoxClicked: App.downloads.model.checkAll(checked)

    Connections {
        target: App.downloads.model
        onAllCheckStateChanged: checked = shouldBeChecked
    }
}
