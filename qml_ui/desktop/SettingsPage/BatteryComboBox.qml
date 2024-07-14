import QtQuick 2.10
import QtQuick.Controls 2.3
import org.freedownloadmanager.fdm 1.0
import org.freedownloadmanager.fdm.dmcoresettings 1.0
import "../BaseElements"
import "../../common"

BaseComboBox {
    id: root
    rightPadding: 5*appWindow.zoom
    leftPadding: 5*appWindow.zoom

    popupVisibleRowsCount: 7
    fontSize: 12*appWindow.fontZoom
    settingsStyle: true

    onActivated: index => saveBatteryMinimumPowerLevelToRunDownloads(model[index].value)

    Component.onCompleted: root.applyCurrentValueToCombo()

    function applyCurrentValueToCombo()
    {
        let cv = parseInt(App.settings.dmcore.value(DmCoreSettings.BatteryMinimumPowerLevelToRunDownloads));
        if (cv <= 0)
            cv = 15;

        let m = [];
        let cindex = -1;

        for (let i = 5; i <= 100; i += 5)
        {
            if (cindex === -1)
            {
                if (i == cv)
                {
                    cindex = m.length;
                }
                else if (i > cv)
                {
                    cindex = m.length;
                    m.push({text: cv+"%", value: cv});
                }
            }

            m.push({text: i+"%", value: i});
        }

        root.model = m;
        root.currentIndex = cindex;
    }

    function saveBatteryMinimumPowerLevelToRunDownloads(value) {
        App.settings.dmcore.setValue(DmCoreSettings.BatteryMinimumPowerLevelToRunDownloads, parseInt(value));
    }
}
