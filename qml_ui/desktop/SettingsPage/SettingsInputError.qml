import QtQuick 2.0
import "../BaseElements"
import "../../common"

Rectangle {
    property Component inputElement
    property string errorMessage

    anchors.bottom: parent.top
    anchors.bottomMargin: 5*appWindow.zoom
    anchors.horizontalCenter: parent.horizontalCenter

    height: errorLbl.height + 16*appWindow.zoom
    width: errorLbl.width + 16*appWindow.zoom
    color: '#fde3e3'
    border.width: 1*appWindow.zoom
    border.color: "#cfa6a9"
    radius: 5*appWindow.zoom

    Rectangle {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.bottom
        anchors.topMargin: -(height/2)
        color: 'transparent'
        width: 12*appWindow.zoom
        height: 12*appWindow.zoom
        clip: true
        WaSvgImage {
            source: appWindow.theme.elementsIcons
            zoom: appWindow.zoom
            x: -20*zoom
            y: -152*zoom
        }
    }

    BaseLabel {
        id: errorLbl
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        text: errorMessage
        color: "#8f272b"
        wrapMode: Text.Wrap
        width: 200*appWindow.zoom
        Component.onCompleted: {
            width = contentWidth < 200*appWindow.zoom ? contentWidth : 200*appWindow.zoom;
        }
        onTextChanged: {
            width = contentWidth < 200*appWindow.zoom ? contentWidth : 200*appWindow.zoom;
        }
    }
}
