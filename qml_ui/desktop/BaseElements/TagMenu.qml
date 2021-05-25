import QtQuick 2.11
import QtQuick.Controls 2.3
import org.freedownloadmanager.fdm 1.0
import "../../common"
import "../BaseElements"

BaseContextMenu {
    id: root
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

    property var tag

    BaseContextMenuItem {
        text: qsTr("Edit") + App.loc.emptyString
        onTriggered: {
            tagsTools.startTagEditing(tag);
            editTagDlg.open();
        }
    }
    BaseContextMenuItem {
        text: qsTr("Remove") + App.loc.emptyString
        onTriggered: {
            removeTagDlg.tagId = tag.id;
            removeTagDlg.open();
        }
    }
}
