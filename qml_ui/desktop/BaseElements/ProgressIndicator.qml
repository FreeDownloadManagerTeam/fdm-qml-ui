import QtQuick
import "V2"

Loader
{
    id: root

    property bool infinityIndicator: false
    property int percent: 0
    property bool inProgress: true
    property bool small: true

    source: Qt.resolvedUrl(appWindow.uiver === 1 ? "DownloadsItemProgressIndicator.qml" : "V2/SlimProgressBar_V2.qml")

    onItemChanged:
    {
        if (!item)
            return;

        if (appWindow.uiver === 1)
        {
            item.infinityIndicator = Qt.binding(() => root.infinityIndicator);
            item.percent = Qt.binding(() => root.percent);
            item.inProgress = Qt.binding(() => root.inProgress);
            item.small = Qt.binding(() => root.small);
        }
        else
        {
            item.indeterminate = Qt.binding(() => root.infinityIndicator);
            item.value = Qt.binding(() => root.percent);
            item.running = Qt.binding(() => root.inProgress);
        }
    }
}
