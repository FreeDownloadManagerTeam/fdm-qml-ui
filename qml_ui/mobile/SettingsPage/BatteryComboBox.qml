import QtQuick 2.10
import QtQuick.Controls 2.4
import "../../qt5compat"
import org.freedownloadmanager.fdm 1.0
import org.freedownloadmanager.fdm.appsettings 1.0
import org.freedownloadmanager.fdm.dmcoresettings 1.0
import "../BaseElements"

BaseComboBox
{
    id: combo

    Component.onCompleted: {

        var m = [];
        for (let i = 5; i <= 100; i += 5)
            m.push({text: i+"%", value: i});
        model = m;

        applyCurrentValueToCombo();
    }

    onActivated: (index) => saveBatteryMinimumPowerLevelToRunDownloads(model[index].value)

    function applyCurrentValueToCombo()
    {
        let cv = parseInt(App.settings.dmcore.value(DmCoreSettings.BatteryMinimumPowerLevelToRunDownloads));
        if (cv <= 0)
            cv = 15;

        for (let i = 0; i < model.length; ++i)
        {
            if (cv === model[i].value)
            {
                combo.currentIndex = i;
                return;
            }
        }

        let m = model;
        m.splice(0,0, {text: cv+"%", value: cv});
        combo.model = m;
        combo.currentIndex = 0;
    }

    function saveBatteryMinimumPowerLevelToRunDownloads(value) {
        App.settings.dmcore.setValue(DmCoreSettings.BatteryMinimumPowerLevelToRunDownloads, parseInt(value));
    }
}
