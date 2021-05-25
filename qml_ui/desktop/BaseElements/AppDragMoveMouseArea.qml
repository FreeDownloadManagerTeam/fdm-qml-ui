import QtQuick 2.0

MouseArea {
    visible: appWindow.macVersion
    property int previousX
    property int previousY

    anchors.fill: parent

    onPressed: {
        previousX = mouseX
        previousY = mouseY
    }

    onMouseXChanged: {
        var dx = mouseX - previousX
        appWindow.setX(appWindow.x + dx)
    }

    onMouseYChanged: {
        var dy = mouseY - previousY
        appWindow.setY(appWindow.y + dy)
    }

    onDoubleClicked: appWindow.resizeWindow()
}
