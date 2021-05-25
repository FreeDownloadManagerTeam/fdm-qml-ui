import QtQuick 2.10
import QtQuick.Controls 2.3
import org.freedownloadmanager.fdm 1.0
import org.freedownloadmanager.fdm.dmcoresettings 1.0
import org.freedownloadmanager.fdm.appsettings 1.0
import org.freedownloadmanager.fdm.tum 1.0

SettingsTextField {
    property int mode: TrafficUsageMode.Low
    property int setting: DmCoreSettings.MaxDownloadSpeed

    implicitWidth: 110


    text: App.settings.tum.value(mode, setting)

    inputMethodHints: Qt.ImhDigitsOnly

    onTextChanged: {
        if (isValid(text)) {
            App.settings.tum.setValue(mode, setting, text);
            appWindow.tumSettingsChanged();
        }
    }

    onDisplayTextChanged: {
        if (isValid(displayText)) {
            App.settings.tum.setValue(mode, setting, displayText);
            appWindow.tumSettingsChanged();
        }
    }

    function isValid(text)
    {
        return text !== "" &&
                /^\d+$/.test(text) &&
                parseInt(text) > 0;
    }
}
