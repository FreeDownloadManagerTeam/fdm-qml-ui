import QtQuick 2.0

BaseLabel
{
    onLinkActivated: Qt.openUrlExternally(link)
    MouseArea {
        width: parent.contentWidth
        height: parent.height
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.NoButton
    }
}
