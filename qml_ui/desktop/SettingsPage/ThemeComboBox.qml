import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.freedownloadmanager.fdm
import org.freedownloadmanager.fdm.dmcoresettings
import org.freedownloadmanager.fdm.appsettings
import "../BaseElements"
import "../../common"

BaseComboBox {
    id: root

    settingsStyle: true

    onActivated: index => uiSettingsTools.settings.theme = model[index].value

    Component.onCompleted: root.reloadCombo()

    Connections {
        target: App.loc
        onCurrentTranslationChanged: root.reloadCombo()
    }

    function reloadCombo() {
        root.model = [
                    {text: qsTr("System"), value: 'system'},
                    {text: qsTr("Light"), value: 'light'},
                    {text: qsTr("Dark"), value: 'dark'},
                ];
        root.currentIndex = root.model.findIndex(e => e.value === uiSettingsTools.settings.theme);
    }
}
