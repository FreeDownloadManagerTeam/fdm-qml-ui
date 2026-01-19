import org.freedownloadmanager.fdm
import org.freedownloadmanager.fdm.dmcoresettings
import org.freedownloadmanager.fdm.tum


NetworkSpeedLimitComboBox
{
    property int mode: TrafficUsageMode.Low
    property int setting: DmCoreSettings.MaxDownloadSpeed

    currentValue: App.settings.tum.value(mode, setting)

    onCurrentValueChanged: {
        App.settings.tum.setValue(mode, setting, currentValue)
        appWindow.tumSettingsChanged();
    }
}
