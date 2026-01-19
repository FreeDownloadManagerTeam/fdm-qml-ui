import QtQuick

BaseLabel
{
    MouseArea {
        width: parent.contentWidth
        height: parent.height
        cursorShape: parent.hoveredLink ? Qt.PointingHandCursor : Qt.ArrowCursor
        acceptedButtons: Qt.NoButton
    }
}
