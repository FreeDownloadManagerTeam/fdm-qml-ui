import QtQuick 2.0

BaseHandCursorLabel
{
    onLinkActivated: (link) => Qt.openUrlExternally(link)
}
