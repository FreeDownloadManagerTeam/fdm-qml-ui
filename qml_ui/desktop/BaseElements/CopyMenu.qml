import QtQuick
import QtQuick.Controls
import org.freedownloadmanager.fdm
import "../BaseElements"

BaseContextMenu {
    id: root
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

    property string text

    Action {
        text: qsTr("Copy") + App.loc.emptyString
        onTriggered: {
            App.clipboard.text = root.text
        }
    }
}
