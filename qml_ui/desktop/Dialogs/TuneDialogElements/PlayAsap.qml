import QtQuick 2.0
import QtQuick.Layouts 1.12
import org.freedownloadmanager.fdm 1.0
import org.freedownloadmanager.fdm.abstractdownloadsui 1.0
import "../../BaseElements"
import "../../../common"

BaseCheckBox
{
    id: root

    text: qsTr("Play file while it is still downloading") + App.loc.emptyString

    xOffset: 0
    checkBoxStyle: "gray"

    onClicked: {
        let info = App.downloads.creator.downloadInfo(downloadTools.requestId, 0);

        if (info)
        {
            info.flags = checked ?
                        info.flags | AbstractDownloadsUi.EnableMediaDownloadToPlayAsap :
                        info.flags & ~AbstractDownloadsUi.EnableMediaDownloadToPlayAsap;
        }
    }

    function initialization()
    {
        checked = false;

        visible = !App.rc.client.active &&
                !downloadTools.batchDownload &&
                App.downloads.creator.downloadInfo(downloadTools.requestId, 0).hasLargeEnoughPreviewableMediaFile(100*1024*1024);
    }

    function apply()
    {
    }
}
