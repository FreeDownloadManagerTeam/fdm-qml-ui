import QtQuick 2.10
import QtQuick.Controls 2.3
import "../BaseElements"

Rectangle {
    id: root
    property string name
    property int textWeight: Font.Bold
    color: "transparent"

    height: headerText.height + 30

    BaseLabel {
        id: headerText
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: 20
        anchors.rightMargin: 20
        anchors.verticalCenter: parent.verticalCenter
        text: root.name
        font.pixelSize: 17
        font.weight: textWeight
        wrapMode: Text.WordWrap
    }

    TextMetrics {
        id:     t_metrics
        font:   headerText.font
        text:   headerText.text
    }
}
