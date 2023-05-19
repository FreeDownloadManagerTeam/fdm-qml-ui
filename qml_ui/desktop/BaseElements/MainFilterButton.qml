import QtQuick 2.10
import QtQuick.Controls 2.3
import "../BaseElements"
import org.freedownloadmanager.fdm.abstractdownloadsui 1.0

BaseFilterButton {
    selected: !downloadsViewTools.downloadsTagFilter &&
              downloadsViewTools.downloadsParentIdFilter == -1 &&
              downloadsViewTools.downloadsStatesFilter == value &&
              downloadsWithMissingFilesTools.missingFilesFilter != AbstractDownloadsUi.MffAcceptMissingFiles
    onClicked: downloadsViewTools.setDownloadsStatesFilter(value)
}
