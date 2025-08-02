import QtQuick 2.11
import QtQuick.Controls 2.3
import org.freedownloadmanager.fdm 1.0
import "../../common"
import "../BaseElements"

BaseContextMenu {
    id: root
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

    signal aboutToOpenDialog()

    property var tag
    property bool askRemoveConfirmation: true

    BaseContextMenuItem {
        text: qsTr("Edit") + App.loc.emptyString
        onTriggered: {
            aboutToOpenDialog();
            tagsTools.startTagEditing(tag);
            editTagDlg.open();
        }
    }
    BaseContextMenuItem {
        text: qsTr("Remove") + App.loc.emptyString
        onTriggered: {
            if (askRemoveConfirmation) {
                aboutToOpenDialog();
                removeTagDlg.tagId = tag.id;
                removeTagDlg.open();
            } else {
                appWindow.removeTag(tag.id);
            }
        }
    }
}
