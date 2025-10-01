import QtQuick 2.10
import QtQuick.Controls 2.3
import org.freedownloadmanager.fdm 1.0
import org.freedownloadmanager.fdm.abstractdownloadsui 1.0
import "../common/Tools"

MouseArea {
    id: root

    property var downloadModel

    z: -1 // for the checkboxes to work

    acceptedButtons: Qt.LeftButton | Qt.RightButton
    hoverEnabled: true

    property int pressY
    property bool justMenuClosed: false
    property int lastIndex: -1

    Timer{
        id:timer
        interval: App.doubleClickInterval
        onTriggered: singleLeftBtnClick(toggleBottomPanelAllowed)
        property bool toggleBottomPanelAllowed: false
    }

    DownloadsItemContextMenuTools {
        id: cmtools
        modelId: downloadModel.id
        finished: downloadModel.finished
        singleDownload: true
    }

    onMouseYChanged: {
        if (pressedButtons == Qt.LeftButton && Math.abs(pressY - mouseY) > 1) {
            var newIndex = listView.indexAt(10, parent.y + mouseY);
            if (newIndex != -1 && newIndex != lastIndex) {
                lastIndex = newIndex;
                var endId = App.downloads.model.idByIndex(lastIndex)
                if (downloadModel.id != endId) {
                    selectedDownloadsTools.selectedByMouse(downloadModel.id, endId);
                } else {
                    App.downloads.model.checkAll(false);
                }
            }
            listView.currentIndex = lastIndex;
        }
    }

    onPressed: function(mouse) {
        if (mouse.button == Qt.LeftButton)
        {
            listView.interactive = false;
            pressY = mouse.y
            lastIndex = -1;
        }
    }

    onReleased: function (mouse) {
        listView.interactive = true;
        if (mouse.button == Qt.LeftButton) {
            if (pressY != mouse.y) {
                var newIndex = listView.indexAt(10, parent.y + mouseY);
                if (newIndex != -1) {
                    var endId = App.downloads.model.idByIndex(newIndex)
                }
                if (newIndex == -1 || downloadModel.id != endId) {
                    justMenuClosed = false;
                    return;
                }
            }
            timer.toggleBottomPanelAllowed = uiSettingsTools.settings.toggleBottomPanelByClickingOnDownload && !justMenuClosed && downloadModel.id == selectedDownloadsTools.currentDownloadId;
        }
        justMenuClosed = false;
        selectedDownloadsTools.downloadMousePressed(downloadModel.id, mouse)
    }

    onClicked: function (mouse) {
        if (mouse.button == Qt.LeftButton) {
            if (timer.running)
            {
                dblClick();
                timer.stop();
            } else {
                timer.restart();
            }
        }

        if (mouse.button === Qt.RightButton)
            showMenu(mouse);

    }

    function singleLeftBtnClick(toggleBottomPanelAllowed) {
        if (toggleBottomPanelAllowed) {
            bottomPanelTools.panelToggleClick();
        }
    }

    function dblClick(mouse) {
        if (downloadModel.hasChildDownloads) {
            downloadsViewTools.setParentDownloadIdFilter(downloadModel.id)
        } else if (cmtools.canBeOpened) {
            if (!App.rc.client.active)
                App.downloads.mgr.openDownload(downloadModel.id, -1)
        }
        else if (downloadModel.fileCount > 1) {
            if (!App.rc.client.active)
                App.downloads.mgr.openDownloadFolder(downloadModel.id, -1)
        }
    }

    function showMenu(mouse)
    {
        var current_ids = selectedDownloadsTools.getCurrentDownloadIds();
        if (!current_ids.length)
            return;

        var component = Qt.createComponent(downloadsViewTools.showingDownloadsWithMissingFilesOnly ?
                                               "DownloadsViewItemContextMenu2.qml" :
                                               "DownloadsViewItemContextMenu.qml");
        var menu = component.createObject(root, {
                                              "modelIds": current_ids
                                          });
        menu.x = Math.round(mouse.x);
        menu.y = Math.round(mouse.y);
        menu.open();
        menu.aboutToHide.connect(function(){
            justMenuClosed = true
            menu.destroy();
        });
    }
}
