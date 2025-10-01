// For downloadsViewTools.showingDownloadsWithMissingFilesOnly === true

import QtQuick
import QtQuick.Controls
import org.freedownloadmanager.fdm
import org.freedownloadmanager.fdm.appfeatures
import org.freedownloadmanager.fdm.abstractdownloadsui
import "BaseElements"
import "../common/Tools";

BaseContextMenu {
    id: root
    property var modelIds: []

    DownloadsItemsTools {
        id: tools
        ids: modelIds
    }

    transformOrigin: Menu.TopRight

    Action {
        text: qsTr("Remove from list") + App.loc.emptyString
        enabled: !tools.locked
        onTriggered: selectedDownloadsTools.removeFromList(modelIds)
    }

    BaseContextMenuSeparator {visible: restartItem.visible}

    BaseContextMenuItem {
        id: restartItem
        text: qsTr("Restart") + App.loc.emptyString
        visible: tools.canBeRestarted
        enabled: !tools.locked
        onTriggered: tools.restartDownloads()
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
