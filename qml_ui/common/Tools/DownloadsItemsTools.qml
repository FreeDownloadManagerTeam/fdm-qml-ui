import QtQuick
import org.freedownloadmanager.fdm
import org.freedownloadmanager.fdm.abstractdownloadsui

Item
{
    property var ids: []

    readonly property alias info: d.firstDownloadInfo
    readonly property alias supportsSequentialDownload: d.supportsSequentialDownload
    readonly property alias sequentialDownload: d.sequentialDownload
    readonly property alias supportsPlayAsap: d.supportsPlayAsap
    readonly property alias playAsap: d.playAsap
    readonly property alias locked: d.locked
    readonly property alias canBeFinalized: d.canBeFinalized
    readonly property alias canBeRestarted: d.canBeRestarted
    readonly property alias canChangePriority: d.canChangePriority
    readonly property alias highPriority: d.highPriority
    readonly property alias normalPriority: d.normalPriority
    readonly property alias lowPriority: d.lowPriority
    readonly property alias canRename: d.canRename
    readonly property alias finished: d.finished
    readonly property alias canMove: d.canMove
    readonly property alias canCheckForUpdate: d.canCheckForUpdate
    readonly property alias canSchedule: d.canSchedule
    readonly property alias canConvertToMp3: d.canConvertToMp3
    readonly property alias canConvertToMp4: d.canConvertToMp4
    readonly property alias canPerformVirusCheck: d.canPerformVirusCheck

    function setSequentialDownload(value)
    {
        DownloadsTools.setSequentialDownload(ids, value);
    }

    function setPlayAsap(value)
    {
        DownloadsTools.setPlayAsap(ids, value);
    }

    function finalizeDownloads()
    {
        DownloadsTools.finalizeDownloads(ids);
    }

    function restartDownloads()
    {
        DownloadsTools.restartDownloads(ids);
    }

    function setDownloadsPriority(value)
    {
        DownloadsTools.setDownloadsPriority(ids, value);
    }

    function checkForUpdate()
    {
        DownloadsTools.checkForUpdate(ids);
    }

    function isDownloadsTagChecked(tagId)
    {
        return DownloadsTools.isDownloadsTagChecked(ids, tagId);
    }

    function setDownloadsTag(tagId, setTag)
    {
        DownloadsTools.setDownloadsTag(ids, tagId, setTag);
    }

    QtObject
    {
        id: d

        property var firstDownloadInfo: null
        property bool supportsSequentialDownload: false
        property bool sequentialDownload: false
        property bool supportsPlayAsap: false
        property bool playAsap: false
        property bool locked: false
        property bool canBeFinalized: false
        property bool canBeRestarted: false
        property bool canChangePriority: false
        property bool highPriority: false
        property bool normalPriority: false
        property bool lowPriority: false
        property bool canRename: false
        property bool finished: false
        property bool canMove: false
        property bool canCheckForUpdate: false
        property bool canSchedule: false
        property bool canConvertToMp3: false
        property bool canConvertToMp4: false
        property bool canPerformVirusCheck: false

        function update()
        {
            if (ids.length === 1)
            {
                let info = App.downloads.infos.info(ids[0]);
                firstDownloadInfo = info;
                supportsSequentialDownload = Qt.binding(() => DownloadsTools.supportsSequentialDownload(info));
                sequentialDownload = Qt.binding(() => info && info.sequentialDownload);
                supportsPlayAsap = Qt.binding(() => DownloadsTools.supportsPlayAsap(info));
                playAsap = Qt.binding(() => info && (info.flags & AbstractDownloadsUi.EnableMediaDownloadToPlayAsap));
                locked = Qt.binding(() => info && info.lockReason);
                canBeFinalized = Qt.binding(() => DownloadsTools.canBeFinalized(info));
                canBeRestarted = Qt.binding(() => DownloadsTools.canBeRestarted(info));
                canChangePriority = Qt.binding(() => DownloadsTools.canChangePriority(info));
                highPriority = Qt.binding(() => info && info.priority == AbstractDownloadsUi.DownloadPriorityHigh);
                normalPriority = Qt.binding(() => info && info.priority == AbstractDownloadsUi.DownloadPriorityNormal);
                lowPriority = Qt.binding(() => info && info.priority == AbstractDownloadsUi.DownloadPriorityLow);
                canRename = Qt.binding(() => DownloadsTools.canRename(info));
                finished = Qt.binding(() => info.finished);
                canMove = Qt.binding(() => DownloadsTools.canMove(info));
                canCheckForUpdate = Qt.binding(() => DownloadsTools.canCheckForUpdate(info));
                canSchedule = Qt.binding(() => DownloadsTools.canSchedule(info));
                canConvertToMp3 = Qt.binding(() => DownloadsTools.canConvertToMp3(info));
                canConvertToMp4 = Qt.binding(() => DownloadsTools.canConvertToMp4(info));
                canPerformVirusCheck = Qt.binding(() => DownloadsTools.isAntivirusEnvOk() && DownloadsTools.canPerformVirusCheck(info));
            }
            else
            {
                let supportsSequentialDownload0 = true;
                let sequentialDownload0 = true;
                let supportsPlayAsap0 = true;
                let playAsap0 = true;
                let locked0 = false;
                let canBeFinalized0 = true;
                let canBeRestarted0 = true;
                let canChangePriority0 = true;
                let highPriority0 = false;
                let normalPriority0 = false;
                let lowPriority0 = false;
                let finished0 = true;
                let firstDownloadInfo0 = null;
                let canMove0 = true;
                let canCheckForUpdate0 = true;
                let canSchedule0 = true;
                let canConvertToMp30 = true;
                let canConvertToMp40 = true;
                let canPerformVirusCheck0 = DownloadsTools.isAntivirusEnvOk();

                for (let i = 0; i < ids.length; ++i)
                {
                    let info = App.downloads.infos.info(ids[i]);
                    if (!info)
                        continue;
                    if (!firstDownloadInfo0)
                        firstDownloadInfo0 = info;
                    if (!DownloadsTools.supportsSequentialDownload(info))
                        supportsSequentialDownload0 = false;
                    if (!info.sequentialDownload)
                        sequentialDownload0 = false;
                    if (!DownloadsTools.supportsPlayAsap(info))
                        supportsPlayAsap0 = false;
                    if (!(info.flags & AbstractDownloadsUi.EnableMediaDownloadToPlayAsap))
                        playAsap0 = false;
                    if (info.lockReason)
                        locked0 = true;
                    if (!DownloadsTools.canBeFinalized(info))
                        canBeFinalized0 = false;
                    if (!DownloadsTools.canBeRestarted(info))
                        canBeRestarted0 = false;
                    if (!DownloadsTools.canChangePriority(info))
                        canChangePriority0 = false;
                    if (info.priority == AbstractDownloadsUi.DownloadPriorityHigh)
                        highPriority0 = true;
                    else if (info.priority == AbstractDownloadsUi.DownloadPriorityNormal)
                        normalPriority0 = true;
                    else if (info.priority == AbstractDownloadsUi.DownloadPriorityLow)
                        lowPriority0 = true;
                    if (!info.finished)
                        finished0 = false;
                    if (!DownloadsTools.canMove(info))
                        canMove0 = false;
                    if (!DownloadsTools.canCheckForUpdate(info))
                        canCheckForUpdate0 = false;
                    if (!DownloadsTools.canSchedule(info))
                        canSchedule0 = false;
                    if (!DownloadsTools.canConvertToMp3(info))
                        canConvertToMp30 = false;
                    if (!DownloadsTools.canConvertToMp4(info))
                        canConvertToMp40 = false;
                    if (!DownloadsTools.canPerformVirusCheck(info))
                        canPerformVirusCheck0 = false;
                }

                firstDownloadInfo = firstDownloadInfo0;
                supportsSequentialDownload = supportsSequentialDownload0;
                sequentialDownload = sequentialDownload0;
                supportsPlayAsap = supportsPlayAsap0;
                playAsap = playAsap0;
                locked = locked0;
                canBeFinalized = canBeFinalized0;
                canBeRestarted = canBeRestarted0;
                canChangePriority = canChangePriority0;
                highPriority = highPriority0;
                normalPriority = normalPriority0;
                lowPriority = lowPriority0;
                canRename = false;
                finished = finished0;
                canMove = canMove0;
                canCheckForUpdate = canCheckForUpdate0;
                canSchedule = canSchedule0;
                canConvertToMp3 = canConvertToMp30;
                canConvertToMp4 = canConvertToMp40;
                canPerformVirusCheck = canPerformVirusCheck0;
            }
        }
    }

    Component.onCompleted: d.update()

    onIdsChanged: d.update()

    Timer
    {
        repeat: true
        interval: 500
        onTriggered: d.update()
        running: ids.length > 1
    }
}
