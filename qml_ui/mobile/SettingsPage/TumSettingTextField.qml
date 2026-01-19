import QtQuick
import QtQuick.Controls
import org.freedownloadmanager.fdm
import org.freedownloadmanager.fdm.dmcoresettings
import org.freedownloadmanager.fdm.appsettings
import org.freedownloadmanager.fdm.tum

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
