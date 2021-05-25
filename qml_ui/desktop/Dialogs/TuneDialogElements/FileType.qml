import QtQuick 2.0
import QtQuick.Layouts 1.3
import org.freedownloadmanager.fdm 1.0
import "../../BaseElements"

ColumnLayout {
    visible: ftcombo.count > 1

    anchors.verticalCenter: parent.verticalCenter
    anchors.left: parent.left

    BaseLabel {
        Layout.topMargin: 6
        text: qsTr("File type:") + App.loc.emptyString
    }

    PreferredFileTypeCombobox {
        id: ftcombo
        Layout.preferredWidth: 150
        Layout.preferredHeight: 30
    }
}
