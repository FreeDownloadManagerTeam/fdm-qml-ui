import QtQuick

BaseHandCursorLabel
{
    onLinkActivated: (link) => Qt.openUrlExternally(link)
}
