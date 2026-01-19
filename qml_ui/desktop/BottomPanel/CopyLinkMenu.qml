import QtQuick
import QtQuick.Controls
import org.freedownloadmanager.fdm
import "../BaseElements"

BaseContextMenu {
    id: root
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

    property string url

    Action {
        text: qsTr("Copy link") + App.loc.emptyString
        onTriggered: {
            App.clipboard.text = url;
        }
    }
}
