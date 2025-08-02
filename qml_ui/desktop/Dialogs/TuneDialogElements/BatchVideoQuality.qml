import QtQuick 2.0
import QtQuick.Layouts 1.3
import org.freedownloadmanager.fdm 1.0
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
