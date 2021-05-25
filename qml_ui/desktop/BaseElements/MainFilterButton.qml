import QtQuick 2.10
import QtQuick.Controls 2.3
import "../BaseElements"

BaseFilterButton {
    property int cnt
    selected: !downloadsViewTools.downloadsTagFilter && downloadsViewTools.downloadsParentIdFilter == -1 && downloadsViewTools.downloadsStatesFilter == value
    onClicked: downloadsViewTools.setDownloadsStatesFilter(value)
}
