import QtQuick
import QtQuick.Window

MouseArea {
    visible: appWindow.macVersion
    property int previousX
    property int previousY
    property bool skipSome: false

    anchors.fill: parent

    onPressed: {
        previousX = mouseX
        previousY = mouseY
    }

    onPressedChanged: {
        skipSome = false;
    }

    onMouseXChanged: {
        if (skipSome || appWindow.visibility == Window.FullScreen)
            return;
        var dx = mouseX - previousX;
        appWindow.setX(appWindow.x + dx);
    }

    onMouseYChanged: {
        if (skipSome || appWindow.visibility == Window.FullScreen)
            return;
        var dy = mouseY - previousY;
        appWindow.setY(appWindow.y + dy);
    }

    onDoubleClicked: {
        if (appWindow.visibility != Window.FullScreen)
        {
            skipSome = true;
            appWindow.resizeWindow();
        }
    }
}
