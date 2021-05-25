import QtQuick 2.0
import "../BaseElements"

Rectangle {
    property Component inputElement
    property string errorMessage

    anchors.bottom: parent.top
    anchors.bottomMargin: 5
    anchors.horizontalCenter: parent.horizontalCenter

    height: errorLbl.height + 16
    width: errorLbl.width + 16
    color: '#fde3e3'
    border.width: 1
    border.color: "#cfa6a9"
    radius: 5

    Rectangle {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.bottom
        anchors.topMargin: -(height/2)
        color: 'transparent'
        width: 12
        height: 12
        clip: true
        Image {
            source: appWindow.theme.elementsIcons
            sourceSize.width: 93
            sourceSize.height: 456
            x: -20
            y: -152
        }
    }

    BaseLabel {
        id: errorLbl
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        text: errorMessage
        color: "#8f272b"
        wrapMode: Text.Wrap
        width: 200
        Component.onCompleted: {
            width = contentWidth < 200 ? contentWidth : 200;
        }
        onTextChanged: {
            width = contentWidth < 200 ? contentWidth : 200;
        }
    }
}
