import QtQuick 2.0
import "../Tools"

Item {

    property int countDownloads: 0
    property bool addManyDownloadsOnLoad: false
    property bool insertDownloadsStarted: false

    Component.onCompleted: {
        if (countDownloads > 0 && addManyDownloadsOnLoad) {
            insertDownloadsStarted = true;
            downloadTools.silentDownload('https://ya.ru');
        }
    }

    function start()
    {
        if (countDownloads > 0) {
            insertDownloadsStarted = true;
            downloadTools.silentDownload('https://ya.ru');
        }
    }

    BuildDownloadTools {
        id: downloadTools
        onCreateSilentDownload: {
            if (insertDownloadsStarted && countDownloads > 0) {
                countDownloads--;
                downloadTools.silentDownload('https://ya.ru');
            }
        }
    }
}
