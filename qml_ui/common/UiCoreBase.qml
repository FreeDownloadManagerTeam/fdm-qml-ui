import QtQuick
import org.freedownloadmanager.fdm
import org.freedownloadmanager.fdm.abstractdownloadsui
import "Tools"

Item
{
    readonly property var snailTools : SnailTools {}

    function priorityText(priority)
    {
        switch(priority)
        {
        case AbstractDownloadsUi.DownloadPriorityHigh: return qsTr("High");
        case AbstractDownloadsUi.DownloadPriorityLow: return qsTr("Low");
        default: return qsTr("Normal");
        }
    }
}
