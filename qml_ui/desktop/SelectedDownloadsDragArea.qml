import QtQuick
import org.freedownloadmanager.fdm
import "../common"

DragArea
{
    property var downloadTitleControl

    readonly property bool multiMode: selectedDownloadsTools.draggableCheckedIds.includes(downloadsItemTools.itemId)
    readonly property var uriList:  multiMode ? selectedDownloadsTools.draggableCheckedFilesDragUriList :
                                    downloadsItemTools.item ? downloadsItemTools.item.filesDragUriList :
                                    []
    enabled: !App.rc.client.active && uriList.length
    mimeData: {"text/uri-list": uriList.join('\n') }
    onTimeToSetDragImageSource: {
        if (multiMode)
        {
            Drag.imageSource = "";
        }
        else
        {
            downloadTitleControl.grabToImage(function(result)
            {
                Drag.imageSource = result.url;
            });
        }
    }
    onDragStarted: appWindow.disableDrop = true
    onDragFinished: function (dropAction)
    {
        appWindow.disableDrop = false;

        if (dropAction == Qt.MoveAction)
        {
            App.downloads.mgr.forceCheckForMissingFiles(
                        multiMode ? selectedDownloadsTools.draggableCheckedIds : [downloadsItemTools.itemId]);
        }
    }
}
