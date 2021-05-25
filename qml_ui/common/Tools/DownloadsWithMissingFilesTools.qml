import QtQuick 2.12
import org.freedownloadmanager.fdm 1.0
import org.freedownloadmanager.fdm.dmcoresettings 1.0
import org.freedownloadmanager.fdm.appsettings 1.0
import org.freedownloadmanager.fdm.abstractdownloadsui 1.0

Item
{
    property bool autoRemoveDownloads: App.settings.toBool(
                                           App.settings.dmcore.value(
                                               DmCoreSettings.AutoRemoveDownloadsWithMissingFiles))


    property var missingFilesFilter: autoRemoveDownloads ? AbstractDownloadsUi.MffAcceptNormal :
                                                           AbstractDownloadsUi.MffOff


    Component.onCompleted:
    {
        App.downloads.model.missingFilesFilter = Qt.binding(function() {
            return missingFilesFilter;
        });
    }

    onAutoRemoveDownloadsChanged:
    {
        App.settings.dmcore.setValue(
                    DmCoreSettings.AutoRemoveDownloadsWithMissingFiles,
                    App.settings.fromBool(autoRemoveDownloads));

        App.downloads.tracker.ignoreDownloadsWithMissingFiles = autoRemoveDownloads;
    }
}
