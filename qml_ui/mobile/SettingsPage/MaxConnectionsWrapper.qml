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
            text: root.labelText
            font.pixelSize: 16
            padding: 3
            anchors.left: parent.left
            horizontalAlignment: Text.AlignLeft
        }

       TumSettingTextField
       {
           id: tumSettingTextField
           mode: root.trafficUsageMode
           setting: root.maxDownloadSpeedSetting
           anchors.left: parent.left
       }
    }

    function isValidTumSetting() {
        return tumSettingTextField.isValid(tumSettingTextField.displayText);
    }
}
