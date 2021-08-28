import QtQuick 2.0

BaseLabel
{
    MouseArea {
        width: parent.contentWidth
        height: parent.height
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.NoButton
    }
}
