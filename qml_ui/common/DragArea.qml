import QtQuick 2.12

Item
{
    id: root

    property var mimeData: ({})

    signal dragStarted()
    signal dragFinished(var dropAction)
    signal timeToSetDragImageSource()

    Drag.active: mouseArea.drag.active
    Drag.mimeData: root.mimeData
    Drag.dragType: Drag.Automatic

    Drag.onDragStarted: root.dragStarted()
    Drag.onDragFinished: root.dragFinished(dropAction)

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        drag.target: root
        onPressed: root.timeToSetDragImageSource()
    }
}
