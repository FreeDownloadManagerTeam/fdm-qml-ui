import QtQuick 2.12
import QtQuick.Layouts 1.12
import org.freedownloadmanager.fdm 1.0
import org.freedownloadmanager.fdm.abstractdownloadsui 1.0
import org.freedownloadmanager.fdm.dmcoresettings 1.0
import "../../BaseElements"
import "../../../common"

RowLayout
{
    property bool noSleepPrevent
    property bool resumeSupportIsNotPresent

    visible: resumeSupportIsNotPresent && noSleepPrevent

    spacing: 10*appWindow.zoom

    WaSvgImage
    {
        source: Qt.resolvedUrl("../../../images/warning_yellow.svg")
        zoom: appWindow.zoom
        Layout.preferredWidth: 32*appWindow.zoom
        Layout.preferredHeight: 32*appWindow.zoom
        Layout.alignment: Qt.AlignTop
    }

    ColumnLayout
    {
        BaseLabel
        {
            text: qsTr("This download may not support resuming.") + App.loc.emptyString
        }

        BaseCheckBox
        {
            id: yesBox
            text: qsTr("Prevent sleep mode when downloading files that don't support resuming") + App.loc.emptyString
            xOffset: 0
            checkBoxStyle: "gray"
        }
    }

    function initialization()
    {
        noSleepPrevent = !App.settings.toBool(App.settings.dmcore.value(DmCoreSettings.PreventOsAutoSleepIfDownloadsRunning));
        resumeSupportIsNotPresent = downloadTools.resumeSupport != AbstractDownloadsUi.DownloadResumeSupportPresent;
        yesBox.checked = false;
    }

    function apply()
    {
        if (yesBox.checked)
        {
            App.settings.dmcore.setValue(
                        DmCoreSettings.PreventOsAutoSleepIfDownloadsRunning,
                        App.settings.fromBool(true));

            App.settings.dmcore.setValue(
                        DmCoreSettings.PreventOsAutoSleepIfDownloadsRunning_IgnoreDownloadsWithResumeSupport,
                        App.settings.fromBool(true));
        }
    }
}
