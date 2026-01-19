import QtQuick
import QtQuick.Controls
import org.freedownloadmanager.fdm
import org.freedownloadmanager.fdm.appsettings
import org.freedownloadmanager.fdm.dmcoresettings
import "../BaseElements"

BaseComboBox
{
    id: combo

    function reloadCombo() {
        combo.model = [
                    {text: qsTr("System"), value: 'system'},
                    {text: qsTr("Light"), value: 'light'},
                    {text: qsTr("Dark"), value: 'dark'},
                ];
        combo.currentIndex = combo.model.findIndex(e => e.value === uiSettingsTools.settings.theme);
    }

    Component.onCompleted: combo.reloadCombo()

    onActivated: (index) => uiSettingsTools.settings.theme = model[index].value

    Connections {
        target: App.loc
        onCurrentTranslationChanged: combo.reloadCombo()
    }
}
