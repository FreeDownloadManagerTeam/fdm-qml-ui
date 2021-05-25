import QtQuick 2.0
import QtQuick.Controls 2.3

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
        //padding: 5

        Label
        {
            //text: qsTr("Low") + App.loc.emptyString
            text: root.comboBoxText
            font.pixelSize: 16
            padding: 3
        }

        TumMaxURatioComboBox
        {
            //mode: TrafficUsageMode.Low
            mode: root.speedLimitMode
            //setting: DmCoreSettings.MaxDownloadSpeed
            setting: speedLimitSetting
        }
    }
}
