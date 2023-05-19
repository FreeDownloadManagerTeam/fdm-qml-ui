import QtQuick 2.10
import QtQuick.Controls 2.3
import "../../common/Tools"

ToolButton {
    property int value
    property bool selected

    property int cnt: 0
    property string title: ""
    property bool includeCntInTitle: true

    text: includeCntInTitle ?
              (cnt > 0 ? title + " (%1)".arg(cnt) : title) :
              title

    height: parent.height

    contentItem: Text {
        text: parent.text
        color: selected ? appWindow.theme.filterBtnSelectedText : appWindow.theme.filterBtnText
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
        leftPadding: 2
        rightPadding: 2
        font.pixelSize: 11*appWindow.fontZoom
    }

    background: Rectangle {
        anchors.fill: parent
        color: appWindow.theme.filterBtnBackground

        Rectangle {
            visible: selected
            color: "#16a4fa"
            width: parent.width
            height: 1*appWindow.zoom
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }
}
