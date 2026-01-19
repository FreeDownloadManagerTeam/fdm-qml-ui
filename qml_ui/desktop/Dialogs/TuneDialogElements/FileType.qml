import QtQuick
import QtQuick.Layouts
import org.freedownloadmanager.fdm
import "../../BaseElements"

ColumnLayout {
    visible: ftcombo.count > 1

    BaseLabel {
        Layout.topMargin: 6*appWindow.zoom
        text: qsTr("File type:") + App.loc.emptyString
        dialogLabel: true
    }

    PreferredFileTypeCombobox {
        id: ftcombo
        comboMinimumWidth: 150*appWindow.zoom
    }
}
