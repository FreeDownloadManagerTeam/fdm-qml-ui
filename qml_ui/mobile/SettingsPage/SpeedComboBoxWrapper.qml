import QtQuick 2.0
import QtQuick.Controls 2.3
import org.freedownloadmanager.fdm.tum 1.0

Rectangle {
    id: root

    width: 160
    height: 70
    color: "transparent"

    property string comboBoxText
    property int speedLimitMode
    property int speedLimitSetting


    Column
    {
        width: parent.width
        height: parent.height

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
}
