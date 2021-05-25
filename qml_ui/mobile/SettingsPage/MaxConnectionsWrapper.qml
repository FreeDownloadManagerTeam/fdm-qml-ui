import QtQuick 2.0
import QtQuick.Controls 2.3

Rectangle {
    id: root

    width: 160
    height: 60
    color: "transparent"

    property int trafficUsageMode
    property int maxDownloadSpeedSetting
    property string labelText

    Column
    {
        width: parent.width
        height: parent.height

       Label
       {
            //text: qsTr("Low") + App.loc.emptyString
            text: root.labelText
            font.pixelSize: 16
            padding: 3
        }

       TumSettingTextField
       {
           id: tumSettingTextField
           //mode: TrafficUsageMode.Low
           mode: root.trafficUsageMode
           //setting: DmCoreSettings.MaxConnections
           setting: root.maxDownloadSpeedSetting
       }
    }

    function isValidTumSetting() {
        return tumSettingTextField.isValid(tumSettingTextField.displayText);
    }
}
