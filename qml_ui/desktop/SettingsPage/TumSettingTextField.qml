import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import org.freedownloadmanager.fdm
import org.freedownloadmanager.fdm.dmcoresettings
import org.freedownloadmanager.fdm.appsettings
import org.freedownloadmanager.fdm.tum

SettingsTextField {
    property int mode: TrafficUsageMode.Low
    property int setting: DmCoreSettings.MaxDownloadSpeed
    property int maxValue: 0

    implicitWidth: 123*appWindow.fontZoom

    Material.accent: Material.Blue

    inputMethodHints: Qt.ImhDigitsOnly
    validator: RegularExpressionValidator { regularExpression: /\d+/ }

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
