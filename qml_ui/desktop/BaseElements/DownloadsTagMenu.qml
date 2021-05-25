import QtQuick 2.11
import QtQuick.Controls 2.3
import org.freedownloadmanager.fdm 1.0
import "../BaseElements"

BaseContextMenu {
    id: root
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

    property int tagId
    property int downloadId

    BaseContextMenuItem {
        text: qsTr("Untag") + App.loc.emptyString
        onTriggered: tagsTools.changeDownloadsTag([downloadId], tagId, false)
    }
}
