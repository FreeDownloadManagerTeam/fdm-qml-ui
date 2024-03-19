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
