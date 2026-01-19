import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.freedownloadmanager.fdm
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
            text: downloadsItemTools.title
            Layout.fillWidth: true
            font.pixelSize: 14
        }

        ToolbarButton {
            id: groupOperationsBtn
            icon.source: Qt.resolvedUrl("../../images/mobile/menu.svg")
            onClicked: {
                selectedDownloadsTools.currentDownloadId = downloadsItemTools.itemId;

                let component = Qt.createComponent("../DownloadsViewItemContextMenu.qml");
                let menu = component.createObject(
                            groupOperationsBtn,
                            {
                                "modelIds": [downloadsItemTools.itemId],
                                "downloadItemPage" : true,
                                "finished": downloadsItemTools.finished,
                                "hasPostFinishedTasks": downloadsItemTools.hasPostFinishedTasks,
                                "priority": downloadsItemTools.priority,
                                "downloadModel": downloadsItemTools.item
                            });
                menu.open();
                menu.aboutToHide.connect(function(){
                    menu.destroy();
                });
            }
        }
    }
}
