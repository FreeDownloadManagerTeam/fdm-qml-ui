import QtQuick 2.10
import QtQuick.Controls 2.3
import org.freedownloadmanager.fdm 1.0
import "BaseElements"

BaseFilterButton {
    selected: downloadsViewTools.downloadsStatesFilter == value
    onClicked: downloadsViewTools.setDownloadsStatesFilter(value)
}
