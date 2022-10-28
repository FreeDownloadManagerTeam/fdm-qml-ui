import QtQuick 2.0

Rectangle {
    visible: !appWindow.macVersion
    height: 34*appWindow.zoom
    anchors.verticalCenter: parent.verticalCenter
    width: 1*appWindow.zoom
    color: "#3e4a5f"
}
