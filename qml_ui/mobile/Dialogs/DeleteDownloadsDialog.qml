import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import org.freedownloadmanager.fdm 1.0
import "../../common/Tools"
import "../BaseElements"

Dialog {
    id: root

    property var downloadIds: []
    property int singleMode: downloadIds.length == 1

    signal downloadsRemoved()

    parent: appWindow.overlay

    x: Math.round((appWindow.width - width) / 2)
    y: Math.round((appWindow.height - height) / 2)

    modal: true

    title: (singleMode ? qsTr("Delete this file?") : qsTr("Delete selected files?")) + App.loc.emptyString
    width: Math.round(appWindow.width * 0.8)

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
