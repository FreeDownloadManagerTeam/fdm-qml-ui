import QtQuick
import QtQuick.Controls
import org.freedownloadmanager.fdm
import "../BaseElements"
import "../../common"

BaseComboBox {
    id: root

    fontSize: 12*appWindow.fontZoom
    settingsStyle: true

    onActivated: index => App.settings.setDbBackupMinInterval(model[index].value);

    Component.onCompleted: root.reloadCombo(App.settings.dbBackupMinInterval())

    Connections {
        target: App.loc
        onCurrentTranslationChanged: root.reloadCombo()
    }

    function reloadCombo(defaultValue) {
        if (defaultValue == -1) {
            defaultValue = 10800;//3 hours
        } else if (root.model.length) {
            defaultValue = root.model[root.currentIndex].value;
        }

        root.model = [ {text: qsTr("5 minutes"), value: 300},
                       {text: qsTr("15 minutes"), value: 900},
                       {text: qsTr("1 hour"), value: 3600},
                       {text: qsTr("3 hours"), value: 10800},
                       {text: qsTr("1 day"), value: 86400} ];

        root.currentIndex = root.model.findIndex(e => e.value == defaultValue);
    }
}
