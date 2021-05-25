import QtQuick 2.0

Rectangle {
    id: root
    width: parent.width
    height: 20
    property string text
    color: "transparent"

    BaseLabel {
        adaptive: true
        labelSize: adaptiveTools.labelSize.highSize
        text: root.text
        anchors.horizontalCenter: parent.horizontalCenter
    }
}
