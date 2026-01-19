import QtQuick
import QtQuick.Controls
import org.freedownloadmanager.fdm
import "BaseElements"

Rectangle
{
    signal switchSelectModeOff()

    width: parent.width
    height: 50
    anchors.bottom: parent.bottom
    color: appWindow.theme.selectModeBarAndPlusBtn
    visible: selectedDownloadsTools.checkedDownloadsCount > 0

    Row {
        anchors.centerIn: parent
        spacing: 4

        // Start button
        SelectModeBarButton
        {
            enabled: selectedDownloadsTools.checkedDownloadsToStartExist
            icon.source: Qt.resolvedUrl("../images/mobile/selected_play.svg")
            onClicked: selectedDownloadsTools.startCheckedDownloads()
        }

        // Pause button
        SelectModeBarButton
        {
            enabled: selectedDownloadsTools.checkedDownloadsToStopExist
            icon.source: Qt.resolvedUrl("../images/mobile/selected_pause.svg")
            onClicked: selectedDownloadsTools.stopCheckedDownloads();
        }

        // Trash button
        SelectModeBarButton
        {
            enabled: !selectedDownloadsTools.selectedDownloadsIsLocked() && selectedDownloadsTools.checkedDownloadsCount > 0
            icon.source: Qt.resolvedUrl("../images/mobile/selected_delete.svg")
            onClicked: {
                deleteDownloadsDialog.downloadIds = App.downloads.model.checkedIds;
                deleteDownloadsDialog.open()
            }
        }

        // Select all
        SelectModeBarButton
        {
            icon.source: App.downloads.model.allCheckState === Qt.Checked ? Qt.resolvedUrl("../images/mobile/unselect_all.svg") : Qt.resolvedUrl("../images/mobile/select_all.svg")
            onClicked: {
                if (App.downloads.model.allCheckState === Qt.Checked) {
                    App.downloads.model.checkAll(false);
                } else {
                    App.downloads.model.checkAll(true);
                }
            }
        }

        SelectModeBarButton
        {
            id: folderBtn
            enabled: selectedDownloadsTools.checkedDownloadsCount > 0
            icon.source: Qt.resolvedUrl("../images/mobile/menu.svg")

            onClicked: {
                var current_ids = selectedDownloadsTools.getCurrentDownloadIds();
                if (!current_ids.length)
                    return;

                var id = current_ids[0];
                var item = App.downloads.infos.info(id);

                var component = Qt.createComponent("DownloadsViewItemContextMenu.qml");
                var menu = component.createObject(folderBtn, {
                                                      "modelIds": current_ids,
                                                      "finished": item.finished,
                                                      "hasPostFinishedTasks": item.hasPostFinishedTasks,
                                                      "priority": item.priority,
                                                      "downloadModel" : item
                                                  });
                menu.open();
                menu.aboutToHide.connect(function(){
                    menu.destroy();
                });
            }
        }
    }
}
