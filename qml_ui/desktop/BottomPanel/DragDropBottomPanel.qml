import QtQuick 2.0

Rectangle {

    property var bottomPanelRct
    property bool movingStarted: false

    id: draggleRct
    width: parent.width
    height: 10
    visible: bottomPanelTools.panelVisible && bottomPanelRct.visible
    color: "transparent"
    MouseArea {
        id: areaElm
        property int startedY: 0
        property int startedPanelHeigth: 0

        cursorShape: Qt.SplitVCursor

        anchors.fill: parent
        onReleased: {
            movingStarted = false;
            posTimer.restart();
        }
        onPressed: function (mouse) {
            movingStarted = true;
            startedY = mouse.y;
            startedPanelHeigth = bottomPanelTools.panelHeigth;
        }
        onPositionChanged: function (mouse) {
            if (movingStarted) {
                bottomPanelTools.setPanelHeigth(startedPanelHeigth - mouse.y + startedY);
            }
        }
    }

    Connections {
        target: bottomPanelTools
        onPanelVisibleChanged: posTimer.restart()
        onPanelHeigthChanged: posTimer.restart()
    }

    Connections {
        target: bottomPanelRct
        onVisibleChanged: posTimer.restart()
    }

    Connections {
        target: appWindow
        onHeightChanged: posTimer.restart()
    }

    Timer {
        id: posTimer
        interval: 100;
        running: false;
        repeat: false
        onTriggered: updatePanelPosition()
    }

    function updatePanelPosition()
    {
        if (!movingStarted) {
            draggleRct.y = bottomPanelRct.y - 10;
        }
    }
}
