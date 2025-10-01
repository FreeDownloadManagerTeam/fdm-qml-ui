pragma Singleton
import QtQuick
import org.freedownloadmanager.fdm
import org.freedownloadmanager.fdm.abstractdownloadsui
import org.freedownloadmanager.fdm.dmcoresettings
import org.freedownloadmanager.fdm.appsettings

QtObject
{
    function nonFinishedInfoHasFlag(info, flag)
    {
        return info &&
                !info.finished &&
                (info.flags & flag);
    }

    function supportsSequentialDownload(info)
    {
        return nonFinishedInfoHasFlag(
                    info,
                    AbstractDownloadsUi.SupportsSequentialDownload);
    }

    function supportsPlayAsap(info)
    {
        return nonFinishedInfoHasFlag(
                    info,
                    AbstractDownloadsUi.SupportsMediaDownloadToPlayAsap);
    }

    function canBeRestarted(info)
    {
        return info &&
                !info.running &&
                !info.stopping &&
                (info.flags & AbstractDownloadsUi.SupportsRestart) != 0 &&
                (info.missingFiles || (!info.finished && info.error.hasError)) &&
                !info.lockReason;
    }

    function canBeFinalized(info)
    {
        return nonFinishedInfoHasFlag(AbstractDownloadsUi.EndlessStream) &&
                !info.lockReason &&
                !info.stopping;
    }

    function canChangePriority(info)
    {
        return info && !info.finished;
    }

    function canRename(info)
    {
        return info &&
                info.finished &&
                info.filesCount === 1 &&
                App.downloads.logics.isFilesLoAllowed(info.id);
    }

    function canMove(info)
    {
        return info &&
                App.downloads.logics.isFilesLoAllowed(info.id);
    }

    function canCheckForUpdate(info)
    {
        return info &&
                info.finished &&
                (info.flags & AbstractDownloadsUi.CanDetectRemoteResourceChanges) &&
                !info.lockReason;
    }

    function canSchedule(info)
    {
        return info &&
                !info.finished &&
                !info.error.hasError;
    }

    function readyToConvert(info)
    {
        return info &&
                info.finished &&
                !info.error.hasError &&
                !info.missingFiles &&
                !info.missingStorage;
    }

    function canConvertToMp3(info)
    {
        return readyToConvert(info) &&
                (info.allFilesTypes & ((1 << AbstractDownloadsUi.VideoFile) | (1 << AbstractDownloadsUi.AudioFile)));
    }

    function hasNonMp4Video(info)
    {
        if (!info)
            return false;

        for (let i = 0; i < info.filesCount; ++i)
        {
            let fileInfo = info.fileInfo(i);
            if (fileInfo.fileType == AbstractDownloadsUi.VideoFile &&
                    fileInfo.suffix.toUpperCase() !== "MP4")
            {
                return true;
            }
        }

        return false;
    }

    function canConvertToMp4(info)
    {
        return readyToConvert(info) &&
                (info.allFilesTypes & (1 << AbstractDownloadsUi.VideoFile)) &&
                hasNonMp4Video(info);
    }

    function canPerformVirusCheck(info)
    {
        return info &&
                info.finished &&
                !info.missingFiles &&
                !info.missingStorage;
    }

    function isAntivirusSettingsOk()
    {
        return App.settings.dmcore.value(DmCoreSettings.AntivirusUid) != "" ||
                (App.settings.dmcore.value(DmCoreSettings.AntivirusPath).length > 0
                   && App.settings.isValidCustomAntivirusArgs(App.settings.dmcore.value(DmCoreSettings.AntivirusArgs)) == '');
    }

    function isAntivirusEnvOk()
    {
        return !App.rc.client.active ||
                isAntivirusSettingsOk(); // we have no UI to setup antivirus settings on a remote machine
    }

    function setSequentialDownload(ids, value)
    {
        for (let i = 0; i < ids.length; ++i)
        {
            let info = App.downloads.infos.info(ids[i]);
            if (supportsSequentialDownload(info))
                info.sequentialDownload = value;
        }
    }

    function setPlayAsap(ids, value)
    {
        for (let i = 0; i < ids.length; ++i)
        {
            let info = App.downloads.infos.info(ids[i]);
            if (supportsPlayAsap(info))
            {
                if (value)
                    info.flags |= AbstractDownloadsUi.EnableMediaDownloadToPlayAsap;
                else
                    info.flags &= ~AbstractDownloadsUi.EnableMediaDownloadToPlayAsap;
            }
        }
    }

    function finalizeDownloads(ids)
    {
        for (let i = 0; i < ids.length; ++i)
        {
            let info = App.downloads.infos.info(ids[i]);
            if (canBeFinalized(info))
                App.downloads.mgr.finalizeDownload(ids[i]);
        }
    }

    function restartDownloads(ids)
    {
        for (let i = 0; i < ids.length; ++i)
        {
            let info = App.downloads.infos.info(ids[i]);
            if (canBeRestarted(info))
                App.downloads.mgr.restartDownload(ids[i]);
        }
    }

    function setDownloadsPriority(ids, value)
    {
        for (let i = 0; i < ids.length; ++i)
        {
            let info = App.downloads.infos.info(ids[i]);
            if (canChangePriority(info))
                info.priority = value;
        }
    }

    function moveDownloads(ids, path)
    {
        for (var i = 0; i < ids.length; ++i)
        {
            if (App.downloads.logics.isFilesLoAllowed(ids[i]))
                App.downloads.moveFilesMgr.moveFiles(ids[i], path);
        }
    }

    function checkForUpdate(ids)
    {
        for (var i = 0; i < ids.length; ++i)
             App.downloads.mgr.checkIfRemoteResourceChanged(ids[i]);
    }
}
