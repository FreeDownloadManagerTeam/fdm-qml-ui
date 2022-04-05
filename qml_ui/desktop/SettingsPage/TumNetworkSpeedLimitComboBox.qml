import QtQuick 2.12
import org.freedownloadmanager.fdm 1.0
import org.freedownloadmanager.fdm.dmcoresettings 1.0
import org.freedownloadmanager.fdm.tum 1.0

NetworkSpeedLimitComboBox {
    property int mode: TrafficUsageMode.Low
    property int setting: DmCoreSettings.MaxDownloadSpeed

    QtObject {
        id: d
        property bool initialized: false
    }

    enabled: mode != TrafficUsageMode.High

    onCurrentValueChanged: {
        if (!d.initialized)
            return;
        App.settings.tum.setValue(mode, setting, currentValue);
        appWindow.tumSettingsChanged();
    }

    Component.onCompleted: {
        currentValue = App.settings.tum.value(mode, setting);
        reloadCombo();
        d.initialized = true;
    }
}
