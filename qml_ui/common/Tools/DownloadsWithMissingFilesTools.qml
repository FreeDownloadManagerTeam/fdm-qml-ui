import QtQuick
import org.freedownloadmanager.fdm
import org.freedownloadmanager.fdm.dmcoresettings
import org.freedownloadmanager.fdm.appsettings
import org.freedownloadmanager.fdm.abstractdownloadsui 

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

    Connections {
        target: App.settings
        onChanged: refresh()
    }

    function refresh()
    {
        autoRemoveDownloads = App.settings.toBool(
                    App.settings.dmcore.value(
                        DmCoreSettings.AutoRemoveDownloadsWithMissingFiles));
    }

    function onAppReady()
    {
        refresh();
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
