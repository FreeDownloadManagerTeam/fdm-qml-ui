import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.freedownloadmanager.fdm
import "../../common/Tools"
import "../BaseElements"

Dialog {
    id: root

    property var downloadIds: []
    property int singleMode: downloadIds.length == 1

    signal downloadsRemoved()

    parent: Overlay.overlay
    anchors.centerIn: parent

    modal: true

    title: (singleMode ? qsTr("Delete this file?") : qsTr("Delete selected files?")) + App.loc.emptyString

    contentItem: GridLayout {
        width: parent.width

        DialogButton
        {
            text: (singleMode ? qsTr("OK") : qsTr("Delete files")) + App.loc.emptyString
            onClicked: {
                App.downloads.mgr.removeDownloads(downloadIds, true, App.downloads.mgr.supportsMoveFilesToTrash());
                root.close();
                downloadsRemoved();
            }
        }

        DialogButton
        {
            Layout.column: appWindow.smallScreen && !singleMode ? 0 : 1
            Layout.row: appWindow.smallScreen && !singleMode ? 1 : 0
            visible: !singleMode
            text: qsTr("Remove from list") + App.loc.emptyString
            onClicked: {
                App.downloads.mgr.removeDownloads(downloadIds, false, false);
                root.close();
                downloadsRemoved();
            }
        }

        DialogButton
        {
            Layout.column: appWindow.smallScreen && !singleMode ? 0 : 2
            Layout.row: appWindow.smallScreen && !singleMode ? 2 : 0
            text: qsTr("Cancel") + App.loc.emptyString
            onClicked: root.close()
        }
    }
}
