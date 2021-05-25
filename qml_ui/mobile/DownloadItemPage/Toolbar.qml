import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
import org.freedownloadmanager.fdm 1.0
import ".."
import "../../common"
import "../BaseElements"

BaseToolBar {
    RowLayout {
        anchors.fill: parent

        ToolbarBackButton {
            onClicked: stackView.pop()
        }

        ToolbarLabel {
            text: downloadsItemTools.tplTitle
            Layout.fillWidth: true
            font.pixelSize: 14
        }

        ToolbarButton {
            id: groupOperationsBtn
            icon.source: Qt.resolvedUrl("../../images/mobile/menu.svg")
            onClicked: {
                selectedDownloadsTools.currentDownloadId = downloadsItemTools.itemId;
                contextMenu.open();
            }

            DownloadsViewItemContextMenu {
                id: contextMenu
                modelIds: [downloadsItemTools.itemId]
                downloadItemPage: true
                finished: downloadsItemTools.finished
                hasPostFinishedTasks: downloadsItemTools.hasPostFinishedTasks
                priority: downloadsItemTools.priority
                downloadModel: downloadsItemTools.item
            }
        }
    }

}
