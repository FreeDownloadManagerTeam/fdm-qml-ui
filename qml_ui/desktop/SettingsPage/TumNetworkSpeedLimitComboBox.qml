import org.freedownloadmanager.fdm 1.0
import org.freedownloadmanager.fdm.dmcoresettings 1.0
import org.freedownloadmanager.fdm.tum 1.0

NetworkSpeedLimitComboBox {
    property int mode: TrafficUsageMode.Low
    property int setting: DmCoreSettings.MaxDownloadSpeed

    enabled: mode != TrafficUsageMode.High

    currentValue: App.settings.tum.value(mode, setting)

    onCurrentValueChanged: {
        App.settings.tum.setValue(mode, setting, currentValue);
        appWindow.tumSettingsChanged();
    }
}
