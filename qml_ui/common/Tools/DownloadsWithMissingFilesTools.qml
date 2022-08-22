import QtQuick 2.12
import org.freedownloadmanager.fdm 1.0
import org.freedownloadmanager.fdm.dmcoresettings 1.0
import org.freedownloadmanager.fdm.appsettings 1.0
import org.freedownloadmanager.fdm.abstractdownloadsui 1.0

Item
{
    property bool autoRemoveDownloads: false

    property var missingFilesFilter: AbstractDownloadsUi.MffOff


    Component.onCompleted:
    {
        if (App.asyncLoadMgr.ready)
            onAppReady();

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

        resetFilter();
    }

    Connections {
        target: App.asyncLoadMgr
        onReadyChanged: {
            if (App.asyncLoadMgr.ready)
                onAppReady();
        }
    }

    function onAppReady()
    {
        autoRemoveDownloads = App.settings.toBool(
                    App.settings.dmcore.value(
                        DmCoreSettings.AutoRemoveDownloadsWithMissingFiles));

        resetFilter();
    }

    function resetFilter()
    {
        missingFilesFilter = Qt.binding(function() {
            return autoRemoveDownloads ? AbstractDownloadsUi.MffAcceptNormal :
                                         AbstractDownloadsUi.MffOff;
        });
    }
}
