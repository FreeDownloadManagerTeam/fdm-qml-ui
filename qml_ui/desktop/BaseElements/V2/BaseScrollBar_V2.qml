import QtQuick
import QtQuick.Controls

ScrollBar
{
    readonly property int myWrapSize: 16*appWindow.zoom
    readonly property int mySize: 4*appWindow.zoom
    readonly property int myRadius: 4*appWindow.zoom

    opacity: (policy === ScrollBar.AlwaysOn || (active && size < 1.0)) ? 1 : 0

    background: Item
    {
        implicitWidth: myWrapSize
        implicitHeight: myWrapSize

        Rectangle
        {
            width: orientation === Qt.Horizontal ? parent.width : mySize
            height: orientation === Qt.Vertical ? parent.height : mySize
            anchors.centerIn: parent
            color: appWindow.theme_v2.bg200
        }
    }

    contentItem: Item
    {
        implicitWidth: myWrapSize
        implicitHeight: myWrapSize

        Rectangle
        {
            width: orientation === Qt.Horizontal ? parent.width : mySize
            height: orientation === Qt.Vertical ? parent.height : mySize
            anchors.centerIn: parent
            radius: myRadius
            color: pressed ? appWindow.theme_v2.bg500 : appWindow.theme_v2.bg400
        }
    }
}
