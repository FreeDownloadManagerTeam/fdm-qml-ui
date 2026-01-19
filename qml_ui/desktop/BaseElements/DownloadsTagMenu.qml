import QtQuick
import QtQuick.Controls
import org.freedownloadmanager.fdm
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
