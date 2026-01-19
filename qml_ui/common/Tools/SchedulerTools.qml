import QtQuick
import org.freedownloadmanager.fdm
import org.freedownloadmanager.fdm.abstractdownloadsui 
import org.freedownloadmanager.fdm.dmcoresettings

Item {

    id: root

    property var downloadIds
    property bool schedulerCheckboxEnabled: false
    property int daysEnabled: 0
    property int startTime: 0
    property int endTime: 0

    property bool tuneAndDownloadDialog: false

    signal settingsSaved()
    signal buildingFinished()

    property bool statusWarning: false
    property string lastError: qsTr("Set days of the week to enable Scheduler") + App.loc.emptyString

    function buildScheduler(ids)
    {
        reset();
        downloadIds = ids;

        //existing schedules
        if (downloadIds && App.downloads.scheduler.isScheduled(downloadIds[0])) {
            schedulerCheckboxEnabled = true;
            daysEnabled = App.downloads.scheduler.days(downloadIds[0]);
            startTime = App.downloads.scheduler.fromTime(downloadIds[0]);
            endTime = App.downloads.scheduler.toTime(downloadIds[0]);
            updateState();
        }

        buildingFinished();
    }

    function reset()
    {
        downloadIds = [];
        schedulerCheckboxEnabled = tuneAndDownloadDialog ?
                    App.settings.toBool(App.settings.dmcore.value(DmCoreSettings.EnableSchedulerForNewDownloads)) :
                    true;
        let schedule = App.settings.toSchedule(App.settings.dmcore.value(DmCoreSettings.ScheduleForNewDownloads));
        daysEnabled = schedule.days;
        startTime = schedule.fromTime;
        endTime = schedule.toTime;
        statusWarning = false;
        updateState();
    }

    function doOK()
    {
        if (!downloadIds)
            return false;
        if (schedulerCheckboxEnabled) {
            setSchedule();
        } else {
            removeSchedule();
        }
        settingsSaved();
    }

    function setSchedule() {
        if (daysEnabled) {
            for (var i = 0; i < downloadIds.length; i++) {
                App.downloads.scheduler.setSchedule(downloadIds[i], daysEnabled, startTime, endTime);
            }
            if (tuneAndDownloadDialog)
            {
                App.settings.dmcore.setValue(
                            DmCoreSettings.ScheduleForNewDownloads,
                            App.settings.fromSchedule(daysEnabled, startTime, endTime));
                App.settings.dmcore.setValue(
                            DmCoreSettings.EnableSchedulerForNewDownloads,
                            App.settings.fromBool(true));
            }
        }
        else {
            removeSchedule();
        }
    }

    function removeSchedule() {
        if (tuneAndDownloadDialog)
        {
            App.settings.dmcore.setValue(
                        DmCoreSettings.EnableSchedulerForNewDownloads,
                        App.settings.fromBool(false));
        }
        for (var i = 0; i < downloadIds.length; i++) {
            if (App.downloads.scheduler.isScheduled(downloadIds[i])) {
                App.downloads.scheduler.removeSchedule(downloadIds[i]);
            }
        }
        settingsSaved();
    }

    function updateState()
    {
        statusWarning = failed() && schedulerCheckboxEnabled;
    }

    function failed()
    {
        return daysEnabled == 0;
    }

    function onDaysEnabledChanged(checked, i)
    {
        if (checked) {
            daysEnabled = daysEnabled | (1<<i);
        } else {
            daysEnabled = daysEnabled & ~(1<<i)
        }
        updateState();
    }

    function onSchedulerCheckboxChanged(checked)
    {
        schedulerCheckboxEnabled = checked;
        updateState();
    }
}
