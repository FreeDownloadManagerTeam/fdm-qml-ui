import QtQuick 2.0

Rectangle {
    id: root

    property string text

    color: "transparent"

    implicitWidth: l.implicitWidth
    implicitHeight: Math.max(l.implicitHeight, 20)

    BaseLabel {
        id: l
        adaptive: true
        labelSize: adaptiveTools.labelSize.highSize
        text: root.text
        anchors.horizontalCenter: parent.horizontalCenter
    }
}
