import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import org.freedownloadmanager.fdm

Slider {
    id: root

    from: 0
    value: 3
    to: 4
    stepSize: 1
    snapMode: Slider.SnapAlways

    property var model: [ {text: qsTr("5 minutes"), value: 300},
        {text: qsTr("15 minutes"), value: 900},
        {text: qsTr("1 hour"), value: 3600},
        {text: qsTr("3 hours"), value: 10800},
        {text: qsTr("1 day"), value: 86400} ]

    property string currentText

    leftPadding: qtbug.leftPadding(20, 40)
    rightPadding: qtbug.rightPadding(20, 40)
    width: parent.width

    Material.accent: enabled ? appWindow.theme.switchTumblerOn : appWindow.theme.switchTumblerOff

    onValueChanged: {
        updateCurrentText();
        App.settings.setDbBackupMinInterval(root.model[root.value].value);
    }

    Component.onCompleted: {
        updateCurrentText();
        root.reloadSlider(App.settings.dbBackupMinInterval())
    }

    Connections {
        target: App.loc
        onCurrentTranslationChanged: root.reloadSlider()
    }

    function reloadSlider(defaultValue) {
        if (defaultValue == -1) {
            defaultValue = 10800;//3 hours
        } else if (root.model.length) {
            defaultValue = root.model[root.value].value;
        }

        root.value = root.model.findIndex(e => e.value == defaultValue);
    }

    function updateCurrentText() {
        root.currentText = root.model[root.value].text;
    }
}
