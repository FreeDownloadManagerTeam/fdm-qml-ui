import QtQuick 2.0
import QtQuick.Controls 2.3

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
