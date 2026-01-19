import QtQuick
import org.freedownloadmanager.fdm

Item
{
    signal readyToShowDialog()

    property var dlg
    property var queue: []

    function hasItems()
    {
        return queue.length > 0;
    }

    function openDialog()
    {
        if (dlg.opened || !queue.length)
            return;

        let item = queue.shift();

        dlg.downloadId = item.downloadId;
        dlg.fileIndex = item.fileIndex;

        dlg.open();
    }

    Connections
    {
        target: App.downloads.mgr
        onMediaReadyToPlay: (downloadId, fileIndex) =>
                            {
                                if (App.rc.client.active)
                                    return;
                                queue.push({downloadId: downloadId, fileIndex: fileIndex});
                                if (!dlg.opened)
                                    readyToShowDialog();
                            }
    }

    Connections
    {
        target: dlg
        onClosed: {
            if (hasItems())
                readyToShowDialog();
        }
    }
}
