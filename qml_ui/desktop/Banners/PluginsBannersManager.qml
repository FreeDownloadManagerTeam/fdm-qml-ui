import QtQuick 2.12
import QtQml 2.12
import org.freedownloadmanager.fdm 1.0

Item
{
    id: root

    property string needToShowForUuid

    Timer
    {
        id: timer
        interval: 3000
        repeat: false
        onTriggered: root.checkAndShow()
    }

    Connections
    {
        target: App.pluginsBanners
        onNeedToShowBanner: (pluginUuid) =>
                            {
                                if (root.needToShowForUuid)
                                    return;
                                root.needToShowForUuid = pluginUuid;
                                root.scheduleCheckAndShow();
                            }
    }

    Connections
    {
        target: appWindow
        onCreateDownloadDialogOpenedChanged: scheduleCheckAndShow()
        onNonCreateDownloadDialogOpenedChanged: scheduleCheckAndShow()
        onActiveChanged: scheduleCheckAndShow()
    }

    function scheduleCheckAndShow(forceRestart)
    {
        if (forceRestart)
            timer.restart();
        else
            timer.start();
    }

    function checkAndShow()
    {
        if (!root.needToShowForUuid ||
                !appWindow.active ||
                appWindow.createDownloadDialogOpened ||
                appWindow.nonCreateDownloadDialogOpened)
        {
            return;
        }

        pluginBannerDlg.pluginUuid = root.needToShowForUuid;
        root.needToShowForUuid = "";

        pluginBannerDlg.open();
    }
}
