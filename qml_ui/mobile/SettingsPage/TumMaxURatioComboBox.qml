import org.freedownloadmanager.fdm
import org.freedownloadmanager.fdm.dmcoresettings
import org.freedownloadmanager.fdm.tum


MaxURatioComboBox
{
    property int mode: TrafficUsageMode.Low
    property int setting: -1

    currentValue: (appWindow.btSupported && setting !== -1) ? App.settings.tum.value(mode, setting) : 0 //0 == unlimited

    onCurrentValueChanged: {
        if (setting !== -1)
            App.settings.tum.setValue(mode, setting, currentValue)
    }
}
