import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Controls.Material 2.4
import "../../qt5compat"
import org.freedownloadmanager.fdm 1.0
import org.freedownloadmanager.fdm.dmcoresettings 1.0
import org.freedownloadmanager.fdm.appsettings 1.0
import org.freedownloadmanager.fdm.tum 1.0

SettingsTextField {
    property int mode: TrafficUsageMode.Low
    property int setting: DmCoreSettings.MaxDownloadSpeed
    property int maxValue: 0

    implicitWidth: 123*appWindow.fontZoom

    Material.accent: Material.Blue

    inputMethodHints: Qt.ImhDigitsOnly
    validator: QtRegExpValidator { regExp: /\d+/ }

    onEditingFinished: {
        if (isValid() && (!maxValue || parseInt(text) <= maxValue))
            App.settings.tum.setValue(mode, setting, text);
    }

    function isValid()
    {
        return text !== "" &&
                /^\d+$/.test(text) &&
                parseInt(text) > 0;
    }

    SettingsInputError {
        visible: maxValue && parseInt(parent.text) > maxValue
        errorMessage: qsTr("Can't be greater than %1").arg(maxValue) + App.loc.emptyString
    }

    Component.onCompleted: {
        text = App.settings.tum.value(mode, setting);
    }
}
