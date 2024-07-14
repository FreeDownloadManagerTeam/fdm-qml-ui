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

    WaSvgImage {
        source: appWindow.theme.elementsIconsRoot + "/triangle_down2.svg"
        zoom: appWindow.zoom
        anchors.top: parent.bottom
        anchors.topMargin: -2*zoom
        anchors.horizontalCenter: parent.horizontalCenter
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
