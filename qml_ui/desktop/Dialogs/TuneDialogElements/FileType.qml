import QtQuick 2.0
import QtQuick.Layouts 1.3
import org.freedownloadmanager.fdm 1.0
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
