import QtQuick
import QtQuick.Controls
import "../../common"

BaseLabel
{
    id: root

    property alias containsMouse: ma.containsMouse

    MouseArea
    {
        id: ma
        enabled: root.truncated
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.NoButton
        BaseToolTip {
            text: root.text
            visible: ma.containsMouse
        }
    }
}
