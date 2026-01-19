import QtQuick
import QtQuick.Layouts
import org.freedownloadmanager.fdm
import "../../BaseElements"

ColumnLayout {
    visible: downloadTools.preferredVideoHeight

    BaseLabel {
        Layout.topMargin: 6*appWindow.zoom
        text: qsTr("Max. video quality:") + App.loc.emptyString
        dialogLabel: true
    }

    PreferredVideoQualityCombobox {
        id: combo
        Layout.minimumWidth: 200*appWindow.zoom
    }
}
