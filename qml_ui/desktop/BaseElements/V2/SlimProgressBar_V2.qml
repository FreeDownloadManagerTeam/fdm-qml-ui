import QtQuick
import QtQuick.Controls

ProgressBar
{
    id: root

    property color bgColor: appWindow.theme_v2.bg300
    property color progressColor : appWindow.theme_v2.primary
    property bool running: false
    property int radius: height

    from: 0
    to: 100

    background: Rectangle {
        implicitHeight: 4*appWindow.zoom
        implicitWidth: 70*appWindow.zoom
        radius: root.radius
        color: root.bgColor
    }

    contentItem: Item {
        clip: true

        Item {
            clip: width < childrenRect.width
            width: root.visualPosition * parent.width
            height: parent.height
            Rectangle {
                visible: !root.indeterminate
                width: Math.max(parent.width, root.radius*2+1)
                height: parent.height
                radius: root.radius
                color: root.progressColor
            }
        }

        Rectangle {
            visible: root.indeterminate && root.running
            width: parent.width/4
            height: parent.height
            radius: root.radius
            color: root.progressColor
            XAnimator on x {
                from: -parent.width
                to: root.width
                loops: Animation.Infinite
                running: root.indeterminate && root.running
                duration: 1000
                onToChanged: if (running) restart()
                onFromChanged: if (running) restart()
            }
        }
    }
}
