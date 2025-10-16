import QtQuick
import org.freedownloadmanager.fdm
import org.freedownloadmanager.fdm.abstractdownloadsui
import "../common"

UiCoreBase
{
    property bool minuteUpdate: false // changes its value each minute
    Timer {
        interval: 60*1000
        repeat: true
        running: true
        onTriggered: minuteUpdate = !minuteUpdate
    }

    function priorityColor(priority)
    {
        switch(priority)
        {
        case AbstractDownloadsUi.DownloadPriorityHigh: return appWindow.theme_v2.secondary;
        case AbstractDownloadsUi.DownloadPriorityLow: return appWindow.theme_v2.danger;
        default: return appWindow.theme_v2.textColor;
        }
    }

    function priorityAndSnailColor(priority)
    {
        return snailTools.isSnail ?
                    appWindow.theme_v2.amber :
                    priorityColor(priority);
    }
}
