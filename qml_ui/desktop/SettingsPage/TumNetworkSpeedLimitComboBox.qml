import QtQuick
import org.freedownloadmanager.fdm
import org.freedownloadmanager.fdm.dmcoresettings
import org.freedownloadmanager.fdm.tum

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
