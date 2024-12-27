pragma Singleton
import QtQuick 2.0
import org.freedownloadmanager.fdm.abstractdownloadsui 1.0

QtObject
{
    function canBeRestarted(info) {
        return !info.running &&
                !info.stopping &&
                (info.flags & AbstractDownloadsUi.SupportsRestart) != 0 &&
                (info.missingFiles || (!info.finished && info.error.hasError)) &&
                !info.lockReason;
    }
}
