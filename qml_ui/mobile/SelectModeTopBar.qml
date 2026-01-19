import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.freedownloadmanager.fdm
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
