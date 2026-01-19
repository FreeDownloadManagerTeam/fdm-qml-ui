import QtQuick

Item
{
    id: root

    property var mimeData: ({})
    property alias mouseCursorShape: mouseArea.cursorShape

    signal dragStarted()
    signal dragFinished(var dropAction)
    signal timeToSetDragImageSource()

    signal justPressed(var mouse)
    signal justReleased(var mouse)
    signal justClicked(var mouse)

    Drag.active: mouseArea.drag.active
    Drag.mimeData: root.mimeData
    Drag.dragType: Drag.Automatic

    Drag.onDragStarted: root.dragStarted()
    Drag.onDragFinished: dropAction => root.dragFinished(dropAction)

    property bool __dragStarted: false
    property var __mousePressed: null
    property var __mouseReleased: null

    Timer {
        id: resetDragStarted
        interval: 500
        onTriggered: __dragStarted = false
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        drag.target: root
        onPressed: mouse => {
            __mousePressed = mouse;
            root.timeToSetDragImageSource()
        }
        onReleased: mouse => {
            __mouseReleased = mouse;
            resetDragStarted.start();
        }
        onClicked: mouse => {
            if (!__dragStarted)
            {
                if (__mousePressed)
                    root.justPressed(__mousePressed)
                if (__mouseReleased)
                    root.justReleased(__mouseReleased)
                root.justClicked(mouse)
            }
            root.__reset();
        }
    }

    onDragStarted: {
        resetDragStarted.stop();
        __dragStarted = true;
    }

    function __reset()
    {
         __dragStarted = false;
        __mousePressed = null;
        __mouseReleased = null;
        resetDragStarted.stop();
    }
}
