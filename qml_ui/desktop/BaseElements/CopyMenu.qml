import QtQuick 2.11
import QtQuick.Controls 2.3
import org.freedownloadmanager.fdm 1.0
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
