import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import org.freedownloadmanager.fdm 1.0
import "../common"
import "./BaseElements"

ExtraToolBar {
    signal switchSelectModeOff()
    visible: false

    RowLayout {
        id: filtersBar
        anchors.fill: parent
        anchors.rightMargin: 60
        spacing: 0

        ToolbarBackButton {
            onClicked: switchSelectModeOff()
        }

        ToolbarLabel {
            text: qsTr("Selected: %1").arg(selectedDownloadsTools.checkedDownloadsCount) + App.loc.emptyString
            Layout.fillWidth: true
        }
    }
}
