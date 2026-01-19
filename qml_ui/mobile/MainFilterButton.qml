import QtQuick
import QtQuick.Controls
import org.freedownloadmanager.fdm
import "BaseElements"

BaseFilterButton {
    selected: downloadsViewTools.downloadsStatesFilter == value
    onClicked: downloadsViewTools.setDownloadsStatesFilter(value)
}
