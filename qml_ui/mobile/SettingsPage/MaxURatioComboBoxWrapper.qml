import QtQuick
import QtQuick.Controls

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

    TumMaxURatioComboBox
    {
        mode: root.speedLimitMode
        setting: speedLimitSetting
        anchors.left: parent.left
    }
}
