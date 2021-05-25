import QtQuick 2.11
import QtQuick.Controls 2.3
import org.freedownloadmanager.fdm 1.0
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
