import QtQuick 2.0
import QtQuick.Layouts 1.3
import org.freedownloadmanager.fdm 1.0
import "../../BaseElements"

ColumnLayout {
    visible: downloadTools.preferredVideoHeight

    anchors.verticalCenter: parent.verticalCenter
    anchors.right: parent.right

    BaseLabel {
        Layout.topMargin: 6
        text: qsTr("Max. video quality:") + App.loc.emptyString
    }

    PreferredVideoQualityCombobox {
        id: combo
        Layout.preferredWidth: 200
        Layout.preferredHeight: 30
    }
}
