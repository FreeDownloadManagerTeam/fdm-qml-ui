// For downloadsViewTools.showingDownloadsWithMissingFilesOnly === true

import QtQuick 2.10
import QtQuick.Controls 2.3
import org.freedownloadmanager.fdm 1.0
import org.freedownloadmanager.fdm.appfeatures 1.0
import org.freedownloadmanager.fdm.abstractdownloadsui 1.0
import "BaseElements"
import "../common/Tools";

BaseContextMenu {
    id: root
    property var modelIds: []
    property bool finished
    property bool canChangeUrl
    property bool supportsMirror
    property bool batchDownload
    property int filesCount: 0
    property bool locked: selectedDownloadsTools.selectedDownloadsIsLocked()

    DownloadsItemContextMenuTools {
        id: contextMenuTools
        modelId: root.modelIds[0]
        finished: root.finished
        singleDownload: modelIds.length === 1
    }

    transformOrigin: Menu.TopRight

    Action {
        text: qsTr("Remove from list") + App.loc.emptyString
        enabled: !locked
        onTriggered: selectedDownloadsTools.removeFromList(modelIds)
    }

    BaseContextMenuSeparator {visible: restartItem.visible}

    BaseContextMenuItem {
        id: restartItem
        text: qsTr("Restart") + App.loc.emptyString
        visible: selectedDownloadsTools.canBeRestarted()
        enabled: !locked
        onTriggered: selectedDownloadsTools.restartDownloads()
    }

    Connections {
        target: appWindow
        onActiveChanged: {
            if (!appWindow.active) {
                close()
            }
        }
    }
}
