import QtQuick
import QtQuick.Controls
import org.freedownloadmanager.fdm.tum

Column {
    id: root

    property string comboBoxText
    property int speedLimitMode
    property int speedLimitSetting

    Label
    {
        text: root.comboBoxText
        font.pixelSize: 16
        padding: 3
        anchors.left: parent.left
        horizontalAlignment: Text.AlignLeft
    }

    TumNetworkSpeedLimitComboBox
    {
        mode: root.speedLimitMode
        setting: speedLimitSetting
        enabled: speedLimitMode !== TrafficUsageMode.High
        anchors.left: parent.left
    }
}
