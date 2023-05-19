import QtQuick 2.12
import org.freedownloadmanager.fdm 1.0
import org.freedownloadmanager.fdm.appconstants 1.0
import "../common/Tools"

Item {
    readonly property string protocolName: "BitTorrent"

    readonly property string settingsTitle: App.my_BT_qsTranslate("Settings", "BitTorrent settings") + App.loc.emptyString

    property string startAllSeedingDownloadsUiText: App.my_BT_qsTranslate("DownloadContextMenu", "Start all seeding downloads") + App.loc.emptyString
    property string stopAllSeedingDownloadsUiText: App.my_BT_qsTranslate("DownloadContextMenu", "Stop all seeding downloads") + App.loc.emptyString

    property string uploaded: qsTr("Uploaded") + App.loc.emptyString
    property string ratio: qsTr("Ratio") + App.loc.emptyString

    function speedHoverText(bytesUploaded, ratioText)
    {
        return uploaded + ": " + App.bytesAsText(bytesUploaded)
                + '\n' +
                ratio + ": " + ratioText;
    }

    function speedHoverLongestText()
    {
        var ss = speedHoverText(999*AppConstants.BytesInKB, "0.98").split('\n');
        var result = ss[0];
        for (var i = 1; i < ss.length; ++i)
        {
            if (ss[i].length > result.length)
                result = ss[i];
        }
        return result;
    }
}
